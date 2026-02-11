#!/usr/bin/env bash

select_from_table() {
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

  choice=$(ui_menu "Select option" \
    1 "Select All" \
    2 "Select By Primary Key" \
    0 "Back") || return

  case "$choice" in
    1)
      tmp_out="$(mktemp)"
      format_table_to_file "$meta_file" "$data_file" "$tmp_out"
      ui_textbox "$APP_NAME - $db.$table" "$tmp_out"
      rm -f "$tmp_out"
      ;;
    2)
      pkval=$(ui_input "Enter primary key value (${cols[$pkIndex]}):")
      [ -z "$pkval" ] && return

      tmp_data="$(mktemp)"
      awk -F"$DELIM" -v idx="$((pkIndex+1))" -v val="$pkval" '($idx==val){print}' "$data_file" > "$tmp_data"

      tmp_out="$(mktemp)"
      format_table_to_file "$meta_file" "$tmp_data" "$tmp_out"
      ui_textbox "$APP_NAME - Result (PK=$pkval)" "$tmp_out"

      rm -f "$tmp_data" "$tmp_out"
      ;;
    0) return ;;
  esac
}
