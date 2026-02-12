#!/usr/bin/env bash

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
CORE_DIR="$PROJECT_DIR/core"

source "$CORE_DIR/config.sh"
source "$CORE_DIR/utils.sh"
source "$CORE_DIR/validate.sh"

source "$CORE_DIR/menus/main_menu.sh"
source "$CORE_DIR/menus/db_menu.sh"

source "$CORE_DIR/main/create_database.sh"
source "$CORE_DIR/main/list_databases.sh"
source "$CORE_DIR/main/connect_database.sh"
source "$CORE_DIR/main/drop_database.sh"

source "$CORE_DIR/db/create_table.sh"
source "$CORE_DIR/db/list_tables.sh"
source "$CORE_DIR/db/drop_table.sh"
source "$CORE_DIR/db/insert_into_table.sh"
source "$CORE_DIR/db/select_from_table.sh"
source "$CORE_DIR/db/delete_from_table.sh"
source "$CORE_DIR/db/update_table.sh"

mkdir -p "$DATA_DIR"
require_dialog
main_menu
