#!/usr/bin/env bash

APP_NAME="PenguinDB"
APP_VER="v1.0"

require_dialog(){
  if ! command -v dialog >/dev/null 2>&1; then
    echo "Error: dialog is not installed."
    echo "Install: sudo apt update && sudo apt install dialog"
    exit 1
  fi
}

ui_msg(){
  require_dialog
  dialog --clear --title "$APP_NAME" --msgbox "$1" 10 70
}

ui_error(){
  require_dialog
  dialog --clear --title "$APP_NAME - Error" --msgbox "$1" 10 70
}

ui_input(){
  require_dialog
  dialog --clear --stdout --title "$APP_NAME" --inputbox "$1" 10 70 "${2:-}"
}

ui_yesno(){
  require_dialog
  dialog --clear --title "$APP_NAME - Confirm" --yesno "$1" 10 70
  return $?
}

ui_menu(){
  require_dialog
  local prompt="$1"; shift
  dialog --clear --stdout --title "$APP_NAME" --menu "$prompt" 18 70 10 "$@"
}

ui_textbox(){
  require_dialog
  dialog --clear --title "$1" --textbox "$2" 20 90
}

normalize_name(){
  local name="$(echo "$1" | sed 's/^ *//; s/ *$//')"
  echo "$name" | tr ' ' '_'
}

valid_name(){
  [[ "$1" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]
}

db_path(){
  echo "$DATA_DIR/$1"
}

meta_dir(){
  echo "$(db_path "$1")/meta"
}

table_data(){
  echo "$(db_path "$1")/$2.data"
}

table_meta(){
  echo "$(meta_dir "$1")/$2.meta"
}

db_exists(){
  [[ -d "$(db_path "$1")" ]]
}

table_exists(){
  [[ -f "$(table_meta "$1" "$2")" && -f "$(table_data "$1" "$2")" ]]
}

value_has_delim(){
  [[ "$1" == *"$DELIM"* ]]
}

build_db_menu_items(){
  local items=()
  local d
  for d in "$DATA_DIR"/*; do
    [ -d "$d" ] || continue
    local name; name="$(basename "$d")"
    items+=("$name" "Database")
  done
  echo "${items[@]}"
}

build_table_menu_items(){
  local db="$1"
  local mdir; mdir="$(meta_dir "$db")"
  local items=()
  local f
  for f in "$mdir"/*.meta; do
    [ -e "$f" ] || continue
    local name; name="$(basename "$f" .meta)"
    items+=("$name" "Table")
  done
  echo "${items[@]}"
}

format_table_to_file(){
  local meta_file="$1"
  local data_file="$2"
  local out_file="$3"

  {
    awk -F: '{ printf "%-16s", $1 } END { print "" }' "$meta_file"
    awk -F: '{ printf "%-16s", "--------------" } END { print "" }' "$meta_file"

    if [ -s "$data_file" ]; then
      awk -F"$DELIM" '{
        for (i=1; i<=NF; i++) printf "%-16s", $i
        print ""
      }' "$data_file"
    else
      echo "(empty)"
    fi
  } > "$out_file"
}
