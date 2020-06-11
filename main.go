package main

import (
	"log"
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("build/html"))
	http.Handle("/", fs)

	log.Println("Listening on :3215")

	err := http.ListenAndServe(":3215", nil)
	if err != nil {
		log.Fatal(err)
	}
}
