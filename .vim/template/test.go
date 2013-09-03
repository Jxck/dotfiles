package main

import (
	"testing"
)

func Test(t *testing.T) {
	if a != b {
		t.Errorf("got %v\nwant %v", a, b)
	}
}
