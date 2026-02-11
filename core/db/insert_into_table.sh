#!/usr/bin/env bash

insert_into_table() {
  local db="$1"
  local mdir; mdir="$(meta_dir "$db")"

  if [ ! -d "$mdir" ] || [ -z "$(ls -A "$mdir" 2>/dev/null)" ]; then
    ui_msg "No tables found. Create a table first."
    return
  fi

  items=($(build_table_menu_items "$db"))
  table=$(ui_menu "Choose table to insert into" "${items[@]}")
  [ -z "$table" ] && return

  local meta_file data_file
  meta_file="$(table_meta "$db" "$table")"
  data_file="$(table_data "$db" "$table")"

  read_meta "$meta_file"
  if [[ "$pkIndex" -lt 0 ]]; then
    ui_error "Table has no primary key."
    return
  fi

  local -a row=()
  local value i

  for i in "${!cols[@]}"; do
    while true; do
      value=$(ui_input "Value for ${cols[$i]} (${types[$i]}):")
      # PK cannot be empty
      if [[ "$i" -eq "$pkIndex" && -z "$value" ]]; then
        ui_error "Primary key cannot be empty."
        continue
      fi

      if [ -n "$value" ] && value_has_delim "$value"; then
        ui_error "Value cannot contain '$DELIM'."
        continue
      fi

      if [[ -n "$value" ]] && ! check_value_type "${types[$i]}" "$value"; then
        ui_error "Invalid value type for ${cols[$i]}."
        continue
      fi

      if [[ "$i" -eq "$pkIndex" ]] && pk_exists "$data_file" "$pkIndex" "$value"; then
        ui_error "Primary key already exists."
        continue
      fi

      row+=("$value")
      break
    done
  done

  line="$(IFS="$DELIM"; echo "${row[*]}")"
  echo "$line" >> "$data_file"
  ui_msg "Row inserted successfully."
}
