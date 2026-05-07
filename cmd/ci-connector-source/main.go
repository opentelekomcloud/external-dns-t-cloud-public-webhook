package main

import (
	"encoding/gob"
	"fmt"
	"net"
	"os"

	"sigs.k8s.io/external-dns/endpoint"
)

const endpointCount = 10

func main() {
	addr := getenv("CONNECTOR_SOURCE_SERVER", "127.0.0.1:18080")
	zoneName := mustGetenv("ZONE_NAME")

	listener, err := net.Listen("tcp", addr)
	if err != nil {
		fatalf("listen on %s: %v", addr, err)
	}
	defer listener.Close()

	fmt.Printf("connector source listening on %s for zone %s\n", addr, zoneName)

	conn, err := listener.Accept()
	if err != nil {
		fatalf("accept connection: %v", err)
	}
	defer conn.Close()

	if err := gob.NewEncoder(conn).Encode(buildEndpoints(zoneName)); err != nil {
		fatalf("encode endpoints: %v", err)
	}
}

func buildEndpoints(zoneName string) []*endpoint.Endpoint {
	endpoints := make([]*endpoint.Endpoint, 0, endpointCount)
	for i := 0; i < endpointCount; i++ {
		name := fmt.Sprintf("ci-%02d.%s", i+1, zoneName)
		target := fmt.Sprintf("192.0.2.%d", i+1)
		endpoints = append(endpoints, endpoint.NewEndpoint(name, endpoint.RecordTypeA, target))
	}
	return endpoints
}

func mustGetenv(name string) string {
	value := os.Getenv(name)
	if value == "" {
		fatalf("%s is required", name)
	}
	return value
}

func getenv(name, fallback string) string {
	value := os.Getenv(name)
	if value != "" {
		return value
	}
	return fallback
}

func fatalf(format string, args ...any) {
	fmt.Fprintf(os.Stderr, format+"\n", args...)
	os.Exit(1)
}
