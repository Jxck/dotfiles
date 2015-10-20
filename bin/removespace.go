package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strings"
)

const HalfSpaceLetter string = "a-zA-Z0-9"
const FullSpaceLetter string = `^` + HalfSpaceLetter

func removespace(s string) string {
	reg := regexp.MustCompile(fmt.Sprintf("([%s]) ([%s])", HalfSpaceLetter, FullSpaceLetter))
	s = reg.ReplaceAllString(s, "$1$2")
	reg = regexp.MustCompile(fmt.Sprintf("([%s]) ([%s])", FullSpaceLetter, HalfSpaceLetter))
	s = reg.ReplaceAllString(s, "$1$2")
	return s
}

func match(pattern, s string) bool {
	matched, err := regexp.MatchString(pattern, s)
	if err != nil {
		log.Fatal(err)
	}
	return matched
}

func format(s string) string {
	return removespace(s)
}

var flag bool = true

func main() {
	file := os.Args[1]
	str, _ := ioutil.ReadFile(file)
	raw := string(str)

	lines := strings.Split(raw, "\n")

	var result []string
	for _, s := range lines {
		if len(s) == 0 {
			// line break
			result = append(result, s)
			continue
		}
		if match("```.*", s) {
			// code block
			flag = !flag
		}
		if flag {
			re := regexp.MustCompile("#{1,4}")
			loc := re.FindStringIndex(s)
			if loc != nil {
				// h1~h4
				s = s[:loc[1]] + format(s[loc[1]:])
			} else if match("- .*", s) {
				// ol
				s = string(s[0:2]) + format(string(s[2:]))
			} else if match("[0-9],.*", s) {
				// li
				s = string(s[0:2]) + format(string(s[2:]))
			} else {
				// plain text
				s = format(s)
			}
		}
		result = append(result, s)
	}

	resulttext := strings.Join(result, "\n")
	ioutil.WriteFile(file, []byte(resulttext), os.ModeType)
}