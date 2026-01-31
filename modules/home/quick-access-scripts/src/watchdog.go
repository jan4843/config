package main

import (
	"fmt"
	"net/http"
	"time"
)

const (
	heartbeatInterval = 15 * time.Second
	watchdogTimeout   = heartbeatInterval + 1*time.Second
)

var lastPingReceivedAt time.Time

func init() {
	AddInjectionJavaScript(fmt.Sprintf(
		`setInterval(() => fetch("http://%s/ping"), %d);`,
		serverAddr,
		heartbeatInterval.Milliseconds()))

	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		lastPingReceivedAt = time.Now()
	})
}

func watchdog() {
	ticker := time.NewTicker(watchdogTimeout)
	defer ticker.Stop()
	Inject()
	for range ticker.C {
		if time.Since(lastPingReceivedAt) > watchdogTimeout {
			Inject()
		}
	}
}
