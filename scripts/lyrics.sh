#!/usr/bin/bash

# --------------------------------------------
# lyrics-fix.sh (MP3 ONLY)
# - scans a directory for .mp3 files
# - checks if lyrics already exist
# - if missing -> fetch via lyricy CLI
# - embeds lyrics safely (dry-run supported)
#
# Dependencies:
#   lyricy
#   eyeD3
#   ffprobe (optional fallback)
# --------------------------------------------

DRY_RUN=0
VERBOSE=0
ONLY_MISSING=0
DIR=""

usage() {
  cat <<EOF
Usage:
  $0 [--dry-run] [--verbose] [--only-missing] <music_dir>

Options:
  --dry-run        Only print what would be changed
  --verbose        Print extra logs
  --only-missing   Only log songs that have NO lyrics (less spam)
EOF
}

log()  { echo "[INFO] $*"; }
warn() { echo "[WARN] $*" >&2; }
err()  { echo "[ERR ] $*" >&2; }

vlog() {
  if [[ "$VERBOSE" -eq 1 ]]; then
    echo "[VERB] $*"
  fi
}

need() {
  command -v "$1" >/dev/null 2>&1 || {
    err "Missing dependency: $1"
    exit 1
  }
}

# ----------------- parse args -----------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --verbose) VERBOSE=1; shift ;;
    --only-missing) ONLY_MISSING=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *)
      if [[ -z "${DIR}" ]]; then
        DIR="$1"
        shift
      else
        err "Unknown extra argument: $1"
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ -z "${DIR}" ]]; then
  usage
  exit 1
fi

if [[ ! -d "${DIR}" ]]; then
  err "Not a directory: ${DIR}"
  exit 1
fi

# ---------------- deps ----------------
need lyricy
need eyeD3
need ffprobe

# ---------------- helpers ----------------

# Detect embedded lyrics in MP3 via eyeD3 (checks USLT)
has_lyrics_mp3() {
  local f="$1"

  # eyeD3 output usually contains a "Lyrics" section when USLT exists
  if eyeD3 "$f" 2>/dev/null | grep -qiE '(^|\s)Lyrics(\s|:|$)'; then
    return 0
  fi

  # fallback tag check (not always reliable but good extra signal)
  local out=""
  out="$(ffprobe -v error \
    -show_entries format_tags \
    -of default=nw=1 \
    "$f" 2>/dev/null | grep -iE 'lyrics' || true)"

  [[ -n "$out" ]]
}

# Filename heuristic: "Artist - Title.mp3"
infer_artist_title() {
  local base="$1"
  base="${base%.*}"

  if [[ "$base" == *" - "* ]]; then
    local artist="${base%% - *}"
    local title="${base#* - }"
    echo "$artist" "|" "$title"
  else
    echo "" "|" "$base"
  fi
}

fetch_lyrics() {
  local artist="$1"
  local title="$2"

  local out=""
  local cmds=()

  cmds+=("lyricy \"$artist\" \"$title\"")
  cmds+=("lyricy search --artist \"$artist\" --title \"$title\"")
  cmds+=("lyricy get --artist \"$artist\" --title \"$title\"")

  for c in "${cmds[@]}"; do
    vlog "Trying: $c"
    # shellcheck disable=SC2086
    out="$(eval $c 2>/dev/null || true)"
    if [[ -n "${out}" ]]; then
      echo "${out}"
      return 0
    fi
  done

  return 1
}

embed_mp3() {
  local f="$1"
  local lyrics="$2"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[DRY] Would embed lyrics (MP3): $(basename "$f")"
    return 0
  fi

  # create backup once
  cp -n -- "$f" "${f}.bak" >/dev/null 2>&1 || true

  local tmp
  tmp="$(mktemp)"
  printf "%s\n" "$lyrics" > "$tmp"

  vlog "Embedding MP3 lyrics using eyeD3..."
  if eyeD3 --quiet --add-lyrics "$tmp" "$f" >/dev/null 2>&1; then
    rm -f "$tmp"
    return 0
  fi

  rm -f "$tmp"
  return 1
}

# ---------------- main scan ----------------

log "Scanning directory: ${DIR}"
log "Dry run: $DRY_RUN | Verbose: $VERBOSE | Only-missing: $ONLY_MISSING"

total=0
withLyrics=0
withoutLyrics=0
embedded=0
fetched=0
failedFetch=0
embedFailed=0

while IFS= read -r -d '' file; do
  ((total++))

  base="$(basename "$file")"

  # If not only-missing AND not dry-run -> log every file as we check it
  if [[ "$DRY_RUN" -eq 0 && "$ONLY_MISSING" -eq 0 ]]; then
    log "Checking: $base"
  fi

  if has_lyrics_mp3 "$file"; then
    ((withLyrics++))

    if [[ "$DRY_RUN" -eq 0 && "$ONLY_MISSING" -eq 0 ]]; then
      log "✅ Has lyrics: $base"
    fi

    continue
  fi

  ((withoutLyrics++))
  log "❌ No lyrics: $base"

  # DRY RUN = stop here
  if [[ "$DRY_RUN" -eq 1 ]]; then
    continue
  fi

  parsed="$(infer_artist_title "$base")"
  artist="$(printf "%s" "$parsed" | cut -d'|' -f1 | xargs)"
  title="$(printf "%s" "$parsed" | cut -d'|' -f2 | xargs)"

  vlog "Infer -> artist='$artist' title='$title'"

  log "→ Fetching lyrics..."
  lyrics="$(fetch_lyrics "$artist" "$title" || true)"

  if [[ -z "$lyrics" ]]; then
    ((failedFetch++))
    warn "⚠️ Lyrics not found (lyricy): $base"
    continue
  fi

  ((fetched++))
  log "✅ Lyrics fetched: $base"

  log "→ Embedding lyrics..."
  if embed_mp3 "$file" "$lyrics"; then
    ((embedded++))
    log "✅ Embedded successfully: $base"
  else
    ((embedFailed++))
    warn "❌ Embed failed: $base"
  fi

done < <(find "$DIR" -type f -iname "*.mp3" -print0) || true

echo
log "========== SUMMARY =========="
log "Scanned songs        : $total"
log "Songs WITH lyrics    : $withLyrics"
log "Songs WITHOUT lyrics : $withoutLyrics"
log "Fetched lyrics       : $fetched"
log "Embedded success     : $embedded"
log "Fetch failures       : $failedFetch"
log "Embed failures       : $embedFailed"

if [[ "$DRY_RUN" -eq 1 ]]; then
  log "Dry-run mode enabled: no files were modified."
fi

if [[ "$total" -eq 0 ]]; then
  warn "No .mp3 files found in: $DIR"
fi
