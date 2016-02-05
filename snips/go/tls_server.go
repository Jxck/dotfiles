package main

import (
	"crypto/tls"
	"log"
	"net"
	"os"
)

func init() {
	log.SetFlags(log.Lshortfile)
}

var p = log.Println

func main() {
	DOTFILES := os.Getenv("DOTFILES")
	addr := "127.0.0.1:3000"
	cert := DOTFILES + "/keys/cert.pem"
	key := DOTFILES + "/keys/key.pem"
	cer, err := tls.LoadX509KeyPair(cert, key)
	if err != nil {
		log.Fatal(err)
	}

	config := &tls.Config{
		Certificates: []tls.Certificate{cer},
		CipherSuites: []uint16{tls.TLS_RSA_WITH_AES_128_CBC_SHA},
	}
	ln, err := tls.Listen("tcp", addr, config)
	if err != nil {
		log.Fatal(err)
	}
	defer ln.Close()

	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Fatal(err)
		}
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	defer conn.Close()
	buf := make([]byte, 1024)
	for {
		i, err := conn.Read(buf)
		if err != nil {
			log.Fatal(err)
		}
		buf = buf[:i]
		p(buf)

		_, err = conn.Write(buf)
		if err != nil {
			log.Fatal(err)
		}
	}
}
