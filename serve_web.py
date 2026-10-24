#!/usr/bin/env python3
"""Serve the Godot web build with the headers Godot's threaded web
export needs (COOP/COEP for SharedArrayBuffer). Run from the project dir:
python3 serve_web.py  (serves Builds/web on port 8090)"""
import http.server
import socketserver
import sys
from functools import partial

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8090
DIRECTORY = "Builds/web"


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Resource-Policy", "cross-origin")
        super().end_headers()


with socketserver.ThreadingTCPServer(("127.0.0.1", PORT), Handler) as httpd:
    httpd.allow_reuse_address = True
    print(f"Serving {DIRECTORY} on 127.0.0.1:{PORT}", flush=True)
    httpd.serve_forever()
