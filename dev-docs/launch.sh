#!/usr/bin/env bash

# ==============================================================================
# FP Mandate Developer Docs Launcher
# Opens the interactive developer docs portal in your default browser.
# ==============================================================================

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOC_FILE="$DIR/index.html"
PORT=8080

if [ ! -f "$DOC_FILE" ]; then
  echo "❌ Error: $DOC_FILE does not exist."
  exit 1
fi

# Check if python3 is installed to run a local server (avoids CORS issues)
if command -v python3 &>/dev/null; then
  echo "🚀 Launching FP Mandate Developer Docs Hub on localhost:$PORT..."
  
  # Open browser in the background after a slight delay
  (sleep 1 && if [[ "$OSTYPE" == "darwin"* ]]; then open "http://localhost:$PORT/index.html"; elif [[ "$OSTYPE" == "linux-gnu"* ]]; then xdg-open "http://localhost:$PORT/index.html"; elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then start "http://localhost:$PORT/index.html"; fi) &
  
  # Start the server with no-cache headers
  cd "$DIR" && python3 -c '
import http.server, sys
class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()
http.server.test(HandlerClass=NoCacheHandler, port=int(sys.argv[1]))
  ' $PORT
else
  echo "⚠️ Python3 not found. Falling back to file:// protocol (CORS restrictions may apply)."
  echo "🚀 Launching FP Mandate Developer Docs Hub..."
  echo "📍 Location: $DOC_FILE"
  
  # Cross-platform open
  if [[ "$OSTYPE" == "darwin"* ]]; then
    open "$DOC_FILE"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    xdg-open "$DOC_FILE" 2>/dev/null || sensible-browser "$DOC_FILE" 2>/dev/null || echo "Please open file://$DOC_FILE in your browser."
  elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    start "$DOC_FILE"
  else
    echo "Please open file://$DOC_FILE in your web browser."
  fi
fi
