#!/usr/bin/env bash

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

is_linux() {
  [ $(uname) == "Linux" ]
}

set_pomodoro() {
  if [ -f "/tmp/break" ]; then
    rm /tmp/break
  fi
  date -d "now + 25 min" +%s > /tmp/date
  touch /tmp/pomodoro
}

set_break() {
  if [ -f "/tmp/pomodoro" ]; then
    rm /tmp/pomodoro
  fi
  date -d "now + 5 min" +%s > /tmp/date
  touch /tmp/break
}
