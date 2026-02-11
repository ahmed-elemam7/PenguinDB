#!/usr/bin/env bash

drop_database() {
  if [ ! -d "$DATA_DIR" ] || [ -z "$(ls -A "$DATA_DIR" 2>/dev/null)" ]; then
    ui_msg "No databases to drop."
    return
  fi

  items=($(build_db_menu_items))
  if [ "${#items[@]}" -eq 0 ]; then
    ui_msg "No databases found."
    return
  fi

  db=$(ui_menu "Choose database to delete" "${items[@]}")
  [ -z "$db" ] && return

  if ui_yesno "Are you sure you want to delete database '$db'?"; then
    rm -rf "$(db_path "$db")"
    ui_msg "Database '$db' deleted."
  fi
}
