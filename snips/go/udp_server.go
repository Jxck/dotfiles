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
	addr, err := net.ResolveUDPAddr("udp", "localhost:3000")
	if err != nil {
		log.Fatal(err)
	}

	conn, err := net.ListenUDP("udp", addr)
	defer conn.Close()
	if err != nil {
		log.Fatal(err)
	}

	buf := make([]byte, 1500)
	i, err := conn.Read(buf)
	p(i)
	if err != nil {
		log.Fatal(err)
	}

	buf = buf[:i]
	log.Println(buf)
}
