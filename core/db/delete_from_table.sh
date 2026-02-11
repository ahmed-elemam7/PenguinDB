#!/usr/bin/env bash

delete_from_table() {
  local db="$1"
  local mdir; mdir="$(meta_dir "$db")"

  if [ ! -d "$mdir" ] || [ -z "$(ls -A "$mdir" 2>/dev/null)" ]; then
    ui_msg "No tables found."
    return
  fi

  items=($(build_table_menu_items "$db"))
  table=$(ui_menu "Choose table" "${items[@]}")
  [ -z "$table" ] && return

  local meta_file data_file
  meta_file="$(table_meta "$db" "$table")"
  data_file="$(table_data "$db" "$table")"

  read_meta "$meta_file"

  while true; do
    pkval=$(ui_input "Enter primary key to delete (${cols[$pkIndex]}):")
    [ -z "$pkval" ] && return
    pk_exists "$data_file" "$pkIndex" "$pkval" && break
    ui_error "No record found with this primary key."
  done

  if ! ui_yesno "Delete record with PK='$pkval'?"; then
    return
  fi

  tmp="$(mktemp)"
  awk -F"$DELIM" -v idx="$((pkIndex+1))" -v val="$pkval" '($idx!=val){print}' "$data_file" > "$tmp"
  mv "$tmp" "$data_file"

  ui_msg "Record deleted successfully."
}
