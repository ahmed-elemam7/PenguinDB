#!/usr/bin/env bash

update_table(){
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
    pkval=$(ui_input "Enter primary key to update (${cols[$pkIndex]}):")
    [ -z "$pkval" ] && return
    pk_exists "$data_file" "$pkIndex" "$pkval" && break
    ui_error "No record found with this primary key."
  done

  ui_msg "Enter new values.\nLeave empty to keep old value.\nPrimary key cannot be updated."

  local -a updates=()
  local i value

  for i in "${!cols[@]}"; do
    if [[ "$i" -eq "$pkIndex" ]]; then
      updates+=("")
      continue
    fi

    while true; do
      value=$(ui_input "New ${cols[$i]} (${types[$i]}): (empty=keep)")
      if [ -z "$value" ]; then
        updates+=("")
        break
      fi

      if value_has_delim "$value"; then
        ui_error "Value cannot contain '$DELIM'."
        continue
      fi

      if ! check_value_type "${types[$i]}" "$value"; then
        ui_error "Invalid value type for ${cols[$i]}."
        continue
      fi

      updates+=("$value")
      break
    done
  done

  tmp="$(mktemp)"
  awk -F"$DELIM" -v OFS="$DELIM" \
    -v pkcol="$((pkIndex+1))" -v pk="$pkval" \
    -v n="${#cols[@]}" \
    -v upd="$(IFS=$'\t'; echo "${updates[*]}")" '
    BEGIN { split(upd, u, "\t") }
    {
      if ($pkcol == pk) {
        for (i = 1; i <= n; i++) {
          if (i != pkcol && u[i] != "") $i = u[i]
        }
      }
      print
    }
  ' "$data_file" > "$tmp"

  mv "$tmp" "$data_file"
  ui_msg "Record updated successfully."
}
