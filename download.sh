#!/usr/bin/env bash

set -euo pipefail

log.info() {
  echo "[INFO]: ${1:-}" >&2
}

log.error() {
  echo "[ERROR]: ${1:-}" >&2
}

usage() ( 
  set +e
  local help_string
  IFS= read -d '' help_string <<EOF
This script initiates a Kanopy download

Usage: $0 [options] <url>

  -s  indicates the provided link is for a series 
EOF
  printf '%s' "$help_string" 

)

main() {
  while getopts ':sh' opt; do
    case "${opt}" in
      s) log.info "Downloading TV Series..." 
         export SERIES=on
         ;;
      h)
        usage
        exit 0
        ;;
      *)
        log.error "Option '${OPTARG}' is invalid"
        exit 1
        ;;
    esac
  done
  shift $(( OPTIND - 1 ))


  # Get url
  #local url="${1:-}"
  #if [[ -z "$url" ]]; then
  #  log.error "url not provided" >&2
  #  return 1
  #fi


  #log.info "Downloading Kanopy URL '$url'"

  # Detect if we're running in Linux or MacOS
  local platform
  local uname_output
  uname_output="$(uname -s)"
  case "${uname_output}" in
    Linux*) 
      platform="linux";;
    Darwin*) 
      platform="macos";;
    *)
      log.error "Unable to determine platform"
      exit 1
  esac 

  log.info "Detected platform '$platform'"
  export PATH="./shaka-packager/$platform:$PATH" 
  export PATH="./N_m3u8DL-RE/$platform:$PATH" 
  source ./.venv/bin/activate
  python3 ./kanopy-downloader.py
}

main "$@"
