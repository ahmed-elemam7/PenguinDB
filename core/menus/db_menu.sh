#!/usr/bin/env bash

db_menu(){
  local db="$1"

  while true; do
    choice=$(ui_menu "$APP_NAME - Database: $db" \
      1 "Create Table" \
      2 "List Tables" \
      3 "Drop Table" \
      4 "Insert Into Table" \
      5 "Select From Table" \
      6 "Delete From Table" \
      7 "Update Record" \
      0 "Back") || break

    case "$choice" in
      1) create_table "$db" ;;
      2) list_tables "$db" ;;
      3) drop_table "$db" ;;
      4) insert_into_table "$db" ;;
      5) select_from_table "$db" ;;
      6) delete_from_table "$db" ;;
      7) update_table "$db" ;;
      0) break ;;
    esac
  done
}
