package main

import (
	"log"
	"net/http"
)

var serverAddr = "127.0.0.1:22722"

func withCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "https://steamloopback.host")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
		next.ServeHTTP(w, r)
	})
}

func main() {
	go watchdog()
	log.Fatal(http.ListenAndServe(
		serverAddr,
		withCORS(http.DefaultServeMux)))
}
