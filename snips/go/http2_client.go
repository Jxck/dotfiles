package main

import (
	"crypto/tls"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func init() {
	log.SetFlags(log.Lshortfile)
}

var p = log.Println

func main() {
	hc := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				InsecureSkipVerify: true,
			},
		},
	}

	resp, err := hc.Get("https://localhost:8080")
	if err != nil {
		log.Fatal(err)
	}

	_, i := ioutil.ReadAll(resp.Body)
	resp.Body.Close()
	fmt.Printf("%s", i)
}
