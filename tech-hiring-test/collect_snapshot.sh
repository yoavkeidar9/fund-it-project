#!/bin/bash
set -euo pipefail

# Find the project and the selected board list
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BOARDS="$SCRIPT_DIR/boards.txt"

# Check the list before starting
[ -f "$BOARDS" ] || { echo "ERROR: boards.txt missing"; exit 1; }

awk 'NF!=2 {bad=1; print "Invalid line:", NR} END {exit bad}' "$BOARDS"

[ "$(wc -l < "$BOARDS")" -eq 55 ] || {
    echo "ERROR: Expected 55 boards"
    exit 1
}

# Create a new UTC snapshot directory
DATE_UTC=$(date -u +%Y-%m-%d)
TIME_UTC=$(date -u +%H%M%SZ)
RUN_DIR="$PROJECT_DIR/raw/$DATE_UTC/$TIME_UTC"

mkdir "$RUN_DIR" || {
    echo "ERROR: Snapshot directory already exists"
    exit 1
}

echo "Snapshot directory: $RUN_DIR"

# Collect only boards listed in boards.txt
while read -r ticker board; do
    echo "Collecting $ticker ($board)..."

    STARTED=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    URL="https://boards-api.greenhouse.io/v1/boards/${board}/jobs?content=true"

    BODY="$RUN_DIR/${ticker}_${board}.response.gz"
    META="$RUN_DIR/${ticker}_${board}.meta.json"
    TEMP="$RUN_DIR/${ticker}_${board}.tmp"

    if HTTP=$(curl -sSL --connect-timeout 15 --max-time 90 \
        -o "$TEMP" -w '%{http_code}' "$URL"); then
        CURL_EXIT=0
    else
        CURL_EXIT=$?
    fi

    [ -f "$TEMP" ] || touch "$TEMP"

    OK=false
    COUNT=0
    ERROR=""

    if [ "$CURL_EXIT" -ne 0 ]; then
        ERROR="curl failed (exit $CURL_EXIT)"
    elif [ "$HTTP" != "200" ]; then
        ERROR="HTTP $HTTP"
    elif jq -e '.jobs | type == "array"' "$TEMP" >/dev/null 2>&1; then
        OK=true
        COUNT=$(jq '.jobs | length' "$TEMP")
    else
        ERROR="Invalid jobs JSON"
    fi

    gzip -c "$TEMP" > "$BODY"
    rm "$TEMP"

    FINISHED=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    jq -n \
        --arg ticker "$ticker" \
        --arg board_token "$board" \
        --arg requested_at_utc "$STARTED" \
        --arg completed_at_utc "$FINISHED" \
        --arg http "$HTTP" \
        --arg error "$ERROR" \
        --arg response_file "$(basename "$BODY")" \
        --argjson curl_exit "$CURL_EXIT" \
        --argjson ok "$OK" \
        --argjson jobs_count "$COUNT" \
        '{
            ticker: $ticker,
            board_token: $board_token,
            requested_at_utc: $requested_at_utc,
            completed_at_utc: $completed_at_utc,
            http_code: ($http | tonumber),
            curl_exit: $curl_exit,
            content_requested: true,
            ok: $ok,
            error: $error,
            jobs_count: $jobs_count,
            response_file: $response_file
        }' > "$META"

    echo "$ticker | HTTP $HTTP | OK $OK | Jobs $COUNT"

done < "$BOARDS"

echo "SNAPSHOT FINISHED"
echo "Saved to: $RUN_DIR"
