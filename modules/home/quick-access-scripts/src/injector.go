package main

import (
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"time"

	"github.com/gorilla/websocket"
)

var injectionJavaScript = ""

func AddInjectionJavaScript(javascript string) {
	injectionJavaScript += javascript + ";\n"
}

func Inject() {
	if shouldPreventInjection() {
		return
	}

	if err := enableCEFDebugger(); err != nil {
		log.Printf("injector: failed to enable CEF Debugger: %v", err)
		return
	}

	url, err := getCEFDebuggerURL()
	if err != nil {
		log.Printf("injector: failed to get CEF Debugger URL: %v", err)
		return
	}

	res, err := evaluateInCEFDebugger(url, `
		(async () => {
			if (window.QuickAccessScriptsInjected) {
				return "QUICKACCESSSCRIPTS_" + "ALREADY_INJECTED";
			}
			window.QuickAccessScriptsInjected = true;
			`+injectionJavaScript+`
			return "QUICKACCESSSCRIPTS_" + "INJECTED";
		})();
	`)
	if err != nil {
		log.Printf("injector: communication failure: %v", err)
	}
	if strings.Contains(string(res), "QUICKACCESSSCRIPTS_ALREADY_INJECTED") {
		log.Printf("injector: already injected")
		return
	}
	if !strings.Contains(string(res), "QUICKACCESSSCRIPTS_INJECTED") {
		log.Printf("injector: evaluation failure: %s", res)
	}
}

var (
	preventFurtherInjections = false
	latestInjectionsAt       [3]time.Time
)

func shouldPreventInjection() bool {
	if preventFurtherInjections {
		return true
	}
	now := time.Now()
	if now.Sub(latestInjectionsAt[2]) < 60*time.Second {
		preventFurtherInjections = true
		log.Println("injector: preventing further injections: too many injections recently")
		return true
	}
	latestInjectionsAt[2] = latestInjectionsAt[1]
	latestInjectionsAt[1] = latestInjectionsAt[0]
	latestInjectionsAt[0] = now
	return false
}

func enableCEFDebugger() error {
	home, err := os.UserHomeDir()
	if err != nil {
		return fmt.Errorf("failed to get user home directory: %w", err)
	}
	path := home + "/.steam/steam/.cef-enable-remote-debugging"

	if _, err := os.Stat(path); err == nil {
		return nil
	}

	f, err := os.Create(path)
	if err != nil {
		return fmt.Errorf("failed to create file %s: %w", path, err)
	}
	f.Close()

	cmd := exec.Command("killall", "steam")
	if err := cmd.Run(); err != nil {
		return fmt.Errorf("failed to restart steam: %w", err)
	}

	return nil
}

func getCEFDebuggerURL() (string, error) {
	resp, err := http.Get("http://127.0.0.1:8080/json/list")
	if err != nil {
		log.Printf("Failed to fetch json/list: %v", err)
		return "", err
	}
	defer resp.Body.Close()

	var targets []struct {
		Title                string `json:"title"`
		WebSocketDebuggerUrl string `json:"webSocketDebuggerUrl"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&targets); err != nil {
		log.Fatalf("Failed to decode json/list: %v", err)
	}

	url := ""
	quickAccessFound := false
	for _, target := range targets {
		if target.Title == "SharedJSContext" {
			url = target.WebSocketDebuggerUrl
		}
		if strings.HasPrefix(target.Title, "QuickAccess") {
			quickAccessFound = true
		}
	}
	if url == "" {
		return "", errors.New("cannot find SharedJSContext target")
	}
	if !quickAccessFound {
		return "", errors.New("cannot find QuickAccess target")
	}
	return url, nil
}

func evaluateInCEFDebugger(url string, expr string) ([]byte, error) {
	msg := map[string]any{
		"id":     0,
		"method": "Runtime.evaluate",
		"params": map[string]any{
			"expression":   expr,
			"awaitPromise": true,
		},
	}

	conn, _, err := websocket.DefaultDialer.Dial(url, nil)
	if err != nil {
		return nil, err
	}
	defer conn.Close()
	if err := conn.WriteJSON(msg); err != nil {
		return nil, err
	}

	_, resp, err := conn.ReadMessage()
	if err != nil {
		return nil, err
	}
	return resp, nil
}
