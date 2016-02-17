package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func init() {
	log.SetFlags(log.Lshortfile)
}

var p = log.Println

// GODEBUG="http2debug=1" or 2
// DEBUG_HTTP2_GOROUTINES=1
func main() {

	DOTFILES := os.Getenv("DOTFILES")
	cert := DOTFILES + "/keys/cert.pem"
	key := DOTFILES + "/keys/key.pem"

	var s http.Server
	s.Addr = ":8080"

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain")
		fmt.Fprintf(w, "Hello World")
	})

	log.Fatal(s.ListenAndServeTLS(cert, key))
}
