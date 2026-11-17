#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BOARDS="$SCRIPT_DIR/boards.txt"

# Validate board list
[ -f "$BOARDS" ] || { echo "ERROR: boards.txt missing"; exit 1; }

awk 'NF != 2 { bad=1 } END { exit bad }' "$BOARDS" || {
    echo "ERROR: Invalid boards.txt"
    exit 1
}

[ "$(wc -l < "$BOARDS")" -eq 55 ] || {
    echo "ERROR: Expected 55 boards"
    exit 1
}

# Capture the UTC start time
START_UTC=$(date -u +%Y-%m-%dT%H:%M:%SZ)
DAY="${START_UTC:0:10}"
HHMM="${START_UTC:11:2}${START_UTC:14:2}"
DEST="$PROJECT_DIR/raw/$DAY/$HHMM.jsonl.gz"

[ ! -e "$DEST" ] || {
    echo "ERROR: Snapshot already exists: $DEST"
    exit 1
}

# Work outside raw until the snapshot is complete
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

OUT="$TMP/snapshot.jsonl"
: > "$OUT"

COUNT=0

while read -r ticker board; do
    echo "Collecting $ticker ($board)..."

    REQUESTED=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    URL="https://boards-api.greenhouse.io/v1/boards/${board}/jobs?content=true"

    HTTP=$(curl -sSL --connect-timeout 15 --max-time 180 \
        --retry 2 \
        -o "$TMP/response.json" \
        -w '%{http_code}' "$URL") || {
        echo "ERROR: curl failed for $board"
        exit 1
    }

    [ "$HTTP" = "200" ] || {
        echo "ERROR: HTTP $HTTP for $board"
        exit 1
    }

    jq -e '.jobs | type == "array"' "$TMP/response.json" >/dev/null || {
        echo "ERROR: Invalid JSON for $board"
        exit 1
    }

    COMPLETED=$(date -u +%Y-%m-%dT%H:%M:%SZ)

    jq -c \
        --arg ticker "$ticker" \
        --arg board "$board" \
        --arg requested "$REQUESTED" \
        --arg completed "$COMPLETED" \
        '{
            ticker: $ticker,
            board_token: $board,
            requested_at_utc: $requested,
            completed_at_utc: $completed,
            http_status: 200,
            ok: true,
            content_requested: true,
            jobs_count: (.jobs | length),
            response: .
        }' "$TMP/response.json" >> "$OUT"

    COUNT=$((COUNT + 1))
    echo "Completed $COUNT/55"
    sleep 1
done < "$BOARDS"

[ "$COUNT" -eq 55 ] || {
    echo "ERROR: Only collected $COUNT boards"
    exit 1
}

# Compress and validate
gzip -c "$OUT" > "$TMP/snapshot.jsonl.gz"
gzip -t "$TMP/snapshot.jsonl.gz"

[ "$(wc -l < "$OUT")" -eq 55 ] || {
    echo "ERROR: Snapshot does not contain 55 records"
    exit 1
}

# Save exactly one immutable snapshot file
mkdir -p "$PROJECT_DIR/raw/$DAY"

[ ! -e "$DEST" ] || {
    echo "ERROR: Destination already exists"
    exit 1
}

mv "$TMP/snapshot.jsonl.gz" "$DEST"

echo "SNAPSHOT FINISHED"
echo "Boards collected: $COUNT"
echo "Saved to: $DEST"
