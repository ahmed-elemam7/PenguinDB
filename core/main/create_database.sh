#!/usr/bin/env bash

create_database(){
  while true; do
    db=$(ui_input "Enter database name (empty = cancel):")
    [ -z "$db" ] && return

    db="$(normalize_name "$db")"

    if ! valid_name "$db"; then
      ui_error "Invalid database name.\nAllowed: letters, numbers, underscore. Must start with letter or underscore."
      continue
    fi

    if db_exists "$db"; then
      ui_error "Database already exists."
      continue
    fi

    mkdir -p "$(db_path "$db")/meta"
    ui_msg "Database '$db' created successfully."
    return
  done
}
