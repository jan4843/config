package main

import (
	_ "embed"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"slices"
	"strings"
	"sync"
)

var scriptsDir string

type Script struct {
	ID      string `json:"id"`
	Name    string `json:"name"`
	Running bool   `json:"running"`
}

//go:embed payload.js
var payload []byte

func init() {
	scriptsDir = os.ExpandEnv("$HOME/.config/quick-access-scripts")

	AddInjectionJavaScript(fmt.Sprintf(
		`window.QuickAccessScriptsBaseURL = "http://%s";`,
		serverAddr))
	AddInjectionJavaScript(string(payload))

	http.HandleFunc("/scripts", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(getScripts())
	})

	http.HandleFunc("/run", func(w http.ResponseWriter, r *http.Request) {
		script := Script{}
		json.NewDecoder(r.Body).Decode(&script)
		w.Write(runScript(&script))
	})
}

func getScripts() (scripts []Script) {
	files, err := os.ReadDir(scriptsDir)
	if err != nil {
		log.Printf("scripts: failed to read dir: %v", err)
		return
	}
	for _, file := range files {
		if file.IsDir() {
			continue
		}
		id := file.Name()
		cmd := exec.Command(scriptsDir + "/" + id)
		out, err := cmd.Output()
		if err != nil {
			log.Printf("scripts: failed to retrieve script name %s: %v", id, err)
			continue
		}
		name := strings.TrimSuffix(string(out), "\n")
		if name == "" {
			name = id
		}
		scripts = append(scripts, Script{
			ID:      id,
			Name:    name,
			Running: getRunning(id),
		})
	}
	return
}

func runScript(s *Script) []byte {
	if strings.Contains(s.ID, "/") {
		return []byte("invalid script")
	}

	setRunning(s.ID, true)
	defer setRunning(s.ID, false)

	cmd := exec.Command(scriptsDir+"/"+s.ID, s.Name)
	out, err := cmd.CombinedOutput()
	if err != nil {
		return []byte(err.Error())
	}
	return out
}

var (
	scriptsMutex   sync.RWMutex
	scriptsRunning []string
)

func setRunning(script string, isRunning bool) {
	scriptsMutex.Lock()
	defer scriptsMutex.Unlock()

	if isRunning {
		scriptsRunning = append(scriptsRunning, script)
	} else {
		for i, s := range scriptsRunning {
			if s == script {
				scriptsRunning = append(scriptsRunning[:i], scriptsRunning[i+1:]...)
				break
			}
		}
	}
}

func getRunning(script string) bool {
	scriptsMutex.RLock()
	defer scriptsMutex.RUnlock()

	return slices.Contains(scriptsRunning, script)
}
