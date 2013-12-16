package main

import (
	"testing"
)

func Test(t *testing.T) {
	if actual != expected {
		t.Errorf("\ngot  %v\nwant %v", actual, expected)
	}
}

var testcase = []struct {
	in, out string
}{
	{"a", "b"},
	{"a", "b"},
}

func TestParameter(t *testing.T) {
	for _, tc := range testcase {
		in := tc.in
		out := tc.out
		if actual != expected {
			t.Errorf("\ngot  %v\nwant %v", actual, expected)
		}
	}
}
