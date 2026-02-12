#!/usr/bin/env bash

create_table(){
  local db="$1"
  local table cols_count

  while true; do
    table=$(ui_input "Enter table name (empty = cancel):")
    [ -z "$table" ] && return
    table="$(normalize_name "$table")"

    if ! valid_name "$table"; then
      ui_error "Invalid table name."
      continue
    fi
    if table_exists "$db" "$table"; then
      ui_error "Table already exists."
      continue
    fi
    break
  done

  while true; do
    cols_count=$(ui_input "Enter number of columns:" "3")
    [ -z "$cols_count" ] && return
    [[ "$cols_count" =~ ^[1-9][0-9]*$ ]] && break
    ui_error "Invalid number."
  done

  mkdir -p "$(meta_dir "$db")"
  local meta_file data_file
  meta_file="$(table_meta "$db" "$table")"
  data_file="$(table_data "$db" "$table")"

  : > "$meta_file"
  : > "$data_file"

  local pk_chosen=0
  local i col dtype pkflag

  for ((i=1; i<=cols_count; i++)); do
    while true; do
      col=$(ui_input "Column $i name:")
      [ -z "$col" ] && { rm -f "$meta_file" "$data_file"; return; }
      col="$(normalize_name "$col")"

      if ! valid_name "$col"; then
        ui_error "Invalid column name."
        continue
      fi
      if grep -q "^${col}:" "$meta_file" 2>/dev/null; then
        ui_error "Duplicate column name."
        continue
      fi
      break
    done

    while true; do
      dtype=$(ui_input "Datatype for $col (int|string|float):" "string")
      [ -z "$dtype" ] && { rm -f "$meta_file" "$data_file"; return; }
      is_valid_type "$dtype" && break
      ui_error "Invalid datatype."
    done

    pkflag=0
    if [[ "$pk_chosen" -eq 0 ]]; then
    if ui_yesno "Make '$col' the Primary Key?"; then
    pkflag=1
    pk_chosen=1
    fi
    fi


    echo "${col}:${dtype}:${pkflag}" >> "$meta_file"
  done

  if [[ "$pk_chosen" -ne 1 ]]; then
    rm -f "$meta_file" "$data_file"
    ui_error "You must choose exactly one primary key. Table creation cancelled."
    return
  fi

  ui_msg "Table '$table' created successfully."
}