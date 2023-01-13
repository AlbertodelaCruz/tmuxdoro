#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
POMODORO_ICON="\U1F345"
BREAK_ICON="\U1F3C1"

source "$CURRENT_DIR/helpers.sh"

pomodoro_status() {
  if helpers::is_linux ; then
     show_timer
  fi
}

handle_reset_timer() {
  is_reset=$(helpers::get_tmux_option "@reset-timer")
  break_time=$(helpers::get_tmux_option "@break_time")
  pomodoro=$(helpers::get_tmux_option "@pomodoro")
  if [ "$is_reset" = "on" ] && [ "$pomodoro" = "on" ]; then
    helpers::update_tmux_option "@reset-timer" "off"
    helpers::set_pomodoro
  fi
  if [ "$is_reset" = "on" ] && [ "$break_time" = "on" ]; then
    helpers::update_tmux_option "@reset-timer" "off"
    helpers::set_break_time
  fi
}

handle_end_timer() {
  is_end=$(helpers::get_tmux_option "@end-timer")
  break_time=$(helpers::get_tmux_option "@break_time")
  pomodoro=$(helpers::get_tmux_option "@pomodoro")
  if [ "$is_end" = "on" ] && [ "$pomodoro" = "on" ]; then
    tmux set-option -gq "@end-timer" "off"
    helpers::set_break_time
    return 0
  fi
  if [ "$is_end" = "on" ] && [ "$break_time" = "on" ]; then
    tmux set-option -gq "@end-timer" "off"
    helpers::set_pomodoro
    return 0
  fi
}

show_timer() {
  handle_reset_timer
  handle_end_timer
  finish_timer=$(helpers::get_tmux_option "@timer")
  now_time=$(date +%s)
  diff=$(( finish_timer - now_time ))
  break_time=$(helpers::get_tmux_option "@break_time")
  pomodoro=$(helpers::get_tmux_option "@pomodoro")
  if [ "$diff" -lt "0" ]; then
    diff=0
  fi
  datediff=$(date -d@$diff -u +%M:%S)
  if [ "$pomodoro" = "on" ]; then
    echo -e "$POMODORO_ICON $datediff"
  fi
  if [ "$break_time" = "on" ]; then
    echo -e "$BREAK_ICON $datediff"
    if [ "$is_reset" = "on" ]; then
      tmux set-option -gq "@reset-timer" "off"
      helpers::set_break_time
    fi
  fi
  if [ "$diff" -eq "0" ] && [ "$pomodoro" = "on" ]; then
      helpers::set_break_time
      return 0
  fi
  if [ "$diff" -eq "0" ] && [ "$break_time" = "on" ]; then
      helpers::set_pomodoro
      return 0
  fi
}

main() {
  pomodoro_status
}

main
