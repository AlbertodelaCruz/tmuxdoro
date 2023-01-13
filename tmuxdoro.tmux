#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

pomodoro_status="#($CURRENT_DIR/scripts/pomodoro_status.sh)"
pomodoro_status_interpolation="\#{pomodoro_status}"

do_interpolation() {
  local string=$1
  local pomodoro_status_interpolated=${string/$pomodoro_status_interpolation/$pomodoro_status}
  echo "$pomodoro_status_interpolated"
}

update_status() {
  local option="$1"
  local option_value="$(helpers::get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  helpers::update_tmux_option "$option" "$new_option_value"
}

main() {
  update_status "status-right"
  update_status "status-left"
}

helpers::initialize_vars
helpers::set_pomodoro
main
