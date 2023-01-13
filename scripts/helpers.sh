#!/usr/bin/env bash

helpers::set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -ogq "$option" "$value"
}

helpers::update_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

helpers::get_tmux_option() {
  local option_value="$(tmux show-option -gqv "$1")"
  echo "$option_value"
}

helpers::is_linux() {
  [ $(uname) == "Linux" ]
}

helpers::set_pomodoro() {
  break_time=$(helpers::get_tmux_option "@break_time")
  if [ "$break_time" = "on" ]; then
    helpers::update_tmux_option "@break_time" "off"
  fi
  timer=$(date -d "now + 25 min" +%s)
  helpers::update_tmux_option "@timer" "$timer"
  helpers::update_tmux_option "@pomodoro" "on"
}

helpers::set_break_time() {
  break_time=$(helpers::get_tmux_option "@pomodoro")
  if [ "$pomodoro" = "on" ]; then
    helpers::update_tmux_option "@pomodoro" "off"
  fi
  timer=$(date -d "now + 5 min" +%s)
  helpers::update_tmux_option "@timer" "$timer"
  helpers::update_tmux_option "@break_time" "on"
}

helpers::initialize_vars() {
  helpers::set_tmux_option "@pomodoro" "off"
  helpers::set_tmux_option "@break_time" "off"
  timer=$(date +%s)
  helpers::set_tmux_option "@timer" "$timer"
}
