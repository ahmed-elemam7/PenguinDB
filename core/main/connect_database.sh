#!/usr/bin/env bash

connect_database(){
  if [ ! -d "$DATA_DIR" ] || [ -z "$(ls -A "$DATA_DIR" 2>/dev/null)" ]; then
    ui_msg "No databases to connect."
    return
  fi

  items=($(build_db_menu_items))
  if [ "${#items[@]}" -eq 0 ]; then
    ui_msg "No databases found."
    return
  fi

  db=$(ui_menu "Choose database" "${items[@]}")
  [ -z "$db" ] && return

  db_menu "$db"
}
