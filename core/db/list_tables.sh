#!/usr/bin/env bash

list_tables(){
  local db="$1"
  local mdir
  mdir="$(meta_dir "$db")"

  if [ ! -d "$mdir" ] || [ -z "$(ls -A "$mdir" 2>/dev/null)" ]; then
    ui_msg "No tables found in database '$db'."
    return
  fi

  tmp="$(mktemp)"
  {
    echo "Tables in database '$db':"
    echo "-------------------------"
    for f in "$mdir"/*.meta; do
      [ -e "$f" ] || continue
      basename "$f" .meta
    done
  } > "$tmp"

  ui_textbox "$APP_NAME - Tables ($db)" "$tmp"
  rm -f "$tmp"
}
