package main

import (
	"bytes"
	"golang.org/x/net/http2/hpack"
	"log"
)

func init() {
	log.SetFlags(log.Lshortfile)
}

var p = log.Println

func main() {
	s := "www.example.com"

	log.Println(len(s))
	log.Println(hpack.HuffmanEncodeLength(s))

	b := hpack.AppendHuffmanString(nil, s)
	log.Printf("%x\n", b)

	var buf bytes.Buffer
	hpack.HuffmanDecode(&buf, b)

	log.Printf("%s\n", buf.String())
}
