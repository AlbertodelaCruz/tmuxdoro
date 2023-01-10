#! /usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

pomodoro_status="#($CURRENT_DIR/scripts/pomodoro_status.sh)"
pomodoro_status_interpolation="\#{pomodoro_status}"

set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

do_interpolation() {
  local string=$1
  local pomodoro_status_interpolated=${string/$pomodoro_status_interpolation/$pomodoro_status}
  echo "$pomodoro_status_interpolated"
}

update_tmux_option() {
  local option=$1
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}

set_pomodoro
main
