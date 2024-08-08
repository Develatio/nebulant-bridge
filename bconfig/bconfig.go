// MIT License
//
// Copyright (C) 2020  Develatio Technologies S.L.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// The code of this file was bassed on WebSocket Chat example from
// gorilla websocket lib: https://github.com/gorilla/websocket/blob/master/examples/chat/client.go

package bconfig

import (
	"log"
	"os"
	"strconv"
)

// Version var
var Version = "DEV build"

// VersionDate var
var VersionDate = ""

// VersionCommit var
var VersionCommit = ""

// VersionGo var
var VersionGo = ""

// PROFILING conf
var PROFILING bool = false

// Bridge addr
var ADDR = ""

// Bridge port
var PORT = "16789"

// Bridge secret
var SECRET = os.Getenv("NEBULANT_BRIDGE_SECRET")

// arg argv conf

var AddrFlag *string
var VersionFlag *bool

var SecretFlag *string
var OriginFlag *string

var CertPathFlag *string
var KeyPathFlag *string
var XtermRootPath *string

// Order of credentials:
// * Environment Variables
// * Shared Credentials file
func init() {
	if os.Getenv("NEBULANT_PROFILING") != "" {
		var err error
		PROFILING, err = strconv.ParseBool(os.Getenv("NEBULANT_PROFILING"))
		if err != nil {
			log.Fatal(err)
		}
	}
}
