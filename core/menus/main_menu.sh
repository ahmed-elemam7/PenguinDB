#!/usr/bin/env bash

main_menu() {
  while true; do
    choice=$(ui_menu "$APP_NAME - Main Menu" \
      1 "Create Database" \
      2 "List Databases" \
      3 "Connect To Database" \
      4 "Drop Database" \
      0 "Exit") || { clear; exit 0; }

    case "$choice" in
      1) create_database ;;
      2) list_databases ;;
      3) connect_database ;;
      4) drop_database ;;
      0) clear; exit 0 ;;
    esac
  done
}
