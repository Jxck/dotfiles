package main

import (
	"log"
	"net"
)

func init() {
	log.SetFlags(log.Lshortfile)
}

var p = log.Println

func main() {
	addr := "localhost:3000"
	ln, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}

	defer ln.Close()
	for {
		conn, err := ln.Accept()
		if err != nil {
			log.Fatal(err)
		}

		go handle(conn)
	}
}

func handle(conn net.Conn) {
	defer conn.Close()

	for {
		buf := make([]byte, 1024)
		i, err := conn.Read(buf)
		if err != nil {
			log.Fatal(err)
		}
		buf = buf[:i]
		p(i, buf)
	}
}
