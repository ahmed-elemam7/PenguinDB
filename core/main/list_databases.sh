#!/usr/bin/env bash

list_databases(){
  if [ ! -d "$DATA_DIR" ] || [ -z "$(ls -A "$DATA_DIR" 2>/dev/null)" ]; then
    ui_msg "No databases found."
    return
  fi

  tmp="$(mktemp)"
  {
    echo "$APP_NAME - Databases"
    echo "------------------"
    for d in "$DATA_DIR"/*; do
      [ -d "$d" ] || continue
      basename "$d"
    done
  } > "$tmp"

  ui_textbox "$APP_NAME - Databases" "$tmp"
  rm -f "$tmp"
}
