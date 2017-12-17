
# vim-i3mux

An interface to control i3 terminal windows from vim

## comands

### I3muxNew <session>
create a new i3 window running a tmux session <name>
```
:I3muxNew a
```


### I3muxKill <session>
destroy the i3 window <name>
```
:I3muxKill a
```

### I3muxCmd <session> \"<command>\"
execute command in i3 window <session>
```
:I3muxCmd a \"echo foo\"
```

### I3muxRedo <session>
redo last command in i3 window <session>
```
I3muxRedo a
```

### I3muxHide <session>
move i3 window <session> to workspace 99
```
I3muxHide a
```

### I3muxShow <session>
move i3 window <session> back to focused workspace
```
I3muxShow a
```

