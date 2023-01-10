#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
POMODORO_ICON="\U1F345"
BREAK_ICON="\U1F3C1"

source "$CURRENT_DIR/helpers.sh"

pomodoro_status() {
  if is_linux ; then
     show_timer
  fi
}

handle_reset_timer() {
  is_reset=$(get_tmux_option "@reset-timer")
  if [ "$is_reset" = "on" ] && [ -f "/tmp/pomodoro" ]; then
    tmux set-option -gq "@reset-timer" "off"
    set_pomodoro
  fi
  if [ "$is_reset" = "on" ] && [ -f "/tmp/break" ]; then
    tmux set-option -gq "@reset-timer" "off"
    set_break
  fi
}

handle_end_timer() {
  is_end=$(get_tmux_option "@end-timer")
  if [ "$is_end" = "on" ] && [ -f "/tmp/pomodoro" ]; then
    tmux set-option -gq "@end-timer" "off"
    set_break
    return 0
  fi
  if [ "$is_end" = "on" ] && [ -f "/tmp/break" ]; then
    tmux set-option -gq "@end-timer" "off"
    set_pomodoro
    return 0
  fi
}

show_timer() {
  handle_reset_timer
  handle_end_timer
  finish_timer=$(cat /tmp/date)
  now_time=$(date +%s)
  diff=$(( finish_timer - now_time ))
  if [ "$diff" -lt "0" ]; then
    diff=0
  fi
  datediff=$(date -d@$diff -u +%M:%S)
  if [ -f "/tmp/pomodoro" ]; then
    echo -e "$POMODORO_ICON $datediff"
  fi
  if [ -f "/tmp/break" ]; then
    echo -e "$BREAK_ICON $datediff"
    if [ "$is_reset" = "on" ]; then
      tmux set-option -gq "@reset-timer" "off"
      set_break
    fi
  fi
  if [ "$diff" -eq "0" ] && [ -f "/tmp/pomodoro" ]; then
      set_break
      return 0
  fi
  if [ "$diff" -eq "0" ] && [ -f "/tmp/break" ]; then
      set_pomodoro
      return 0
  fi
}

main() {
  pomodoro_status
}

main
