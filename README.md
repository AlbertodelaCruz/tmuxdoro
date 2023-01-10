# tmuxdoro

tmux plugin to show a pomodoro timer

Usage
-----

Supports the following OS

* Linux

Installation
------------

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add the plugin to your `.tmux.conf`:

```
set -g @plugin 'albertodelaCruz/tmuxdoro'
```

you can also configure some bidings for reset and end timers

```
set-option -ogq @reset-timer off
set-option -ogq @end-timer off
unbind r
unbind e
bind r set-option -gq @reset-timer on
bind e set-option -gq @end-timer on

```
in this case, we are binding 'r' and 'e' keys

Hit `prefix + I` to download the plugin and source it.

Configure
---------

Set in your `status-left` or `status-right` and add:

```
#{pomodoro_status}
```

ToDos
-----
- Pomodoro and rest time configurable (now they are fixed to 25 and 5 min)
- More supported OS
- Better handling state and time
- Improve code
