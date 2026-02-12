#!/usr/bin/env bash

drop_table(){
  local db="$1"
  local mdir; mdir="$(meta_dir "$db")"

  if [ ! -d "$mdir" ] || [ -z "$(ls -A "$mdir" 2>/dev/null)" ]; then
    ui_msg "No tables to drop."
    return
  fi

  items=($(build_table_menu_items "$db"))
  if [ "${#items[@]}" -eq 0 ]; then
    ui_msg "No tables found."
    return
  fi

  table=$(ui_menu "Choose table to delete" "${items[@]}")
  [ -z "$table" ] && return

  if ui_yesno "Delete table '$table'?"; then
    rm -f "$(table_meta "$db" "$table")" "$(table_data "$db" "$table")"
    ui_msg "Table '$table' deleted."
  fi
}
