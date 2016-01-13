package main

import (
	"crypto/tls"
	"log"
)

func init() {
	log.SetFlags(log.Lshortfile)
}

var p = log.Println

func main() {
	addr := "127.0.0.1:3000"

	conf := &tls.Config{
		InsecureSkipVerify: true,
	}

	conn, err := tls.Dial("tcp", addr, conf)
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	_, err = conn.Write([]byte("hello\n"))
	if err != nil {
		log.Fatal(err)
	}

	buf := make([]byte, 1024)
	i, err := conn.Read(buf)
	if err != nil {
		log.Fatal(err)
	}

	buf = buf[:i]
	p(buf)
}
