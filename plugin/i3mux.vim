if !exists("g:i3mux_loaded") 
    let g:i3mux_loaded=1
    let g:i3mux_last_window=0
    let g:i3mux_windows={}
endif

function! i3mux#new (window)
    "" get window id of this vim window
    let thisid=systemlist("i3-msg -t get_tree | jq \" recurse(.nodes[]) | select(.focused==true) | .window\"")[0]
    "" i3: split v, start gnome-terminal running tmux
    exec ":!(i3-msg split v;i3-msg exec \"gnome-terminal -- tmux new-session -s vi_dev_" . a:window . "\") > /dev/null"
    sleep 100m
    "" get window id of the new window
    let g:i3mux_windows[a:window]=systemlist("i3-msg -t get_tree | jq \" recurse(.nodes[]) | select(.focused==true) | .window\"")[0]
    let g:i3mux_last_window=a:window
    "" focus vim again
    exec ":!(i3-msg [id=" . thisid . "] focus) > /dev/null"
    redraw!
endfunction

function! i3mux#cmd(margs)
    exec ":!(tmux send-keys -t vi_dev_" . a:margs . " Enter &) > /dev/null"
    sleep 100m
    redraw!
endfunction

function! i3mux#redo(window)
    exec ":!(tmux send-keys -t vi_dev_" . a:window . " Up Enter &) > /dev/null"
    sleep 100m
    redraw!
endfunction

function! i3mux#kill(window)
    exec ":!(tmux send-keys -t vi_dev_" . a:window . " \" exit\" Enter &) > /dev/null"
    sleep 100m
    redraw!
endfunction

function! i3mux#hide (window)
    exec ":!(i3-msg [id=" . g:i3mux_windows[a:window] . "] move container to workspace 99) > /dev/null"
    sleep 100m
    redraw!
endfunction

function! i3mux#show (...)
    exec ":!(i3-msg [id=" .  g:i3mux_windows[a:window] . "] move container to workspace current) > /dev/null"
    sleep 100m
    redraw!
endfunction

function! i3mux#detach (window)
    exec ":!(tmux send-keys -t vi_dev_" . a:window . " \" tmux detach\" Enter &) > /dev/null"
    sleep 100m
    redraw!
endfunction

function! i3mux#attach (window)
    "" get window id of this vim window
    let thisid=systemlist("i3-msg -t get_tree | jq \" recurse(.nodes[]) | select(.focused==true) | .window\"")[0]
    "" i3: split v, start gnome-terminal running tmux
    exec ":!(i3-msg split v;i3-msg exec \"gnome-terminal -- tmux attach -t vi_dev_" . a:window . "\") > /dev/null"
    sleep 100m
    "" get window id of the new window
    let g:i3mux_windows[a:window]=systemlist("i3-msg -t get_tree | jq \" recurse(.nodes[]) | select(.focused==true) | .window\"")[0]
    let g:i3mux_last_window=a:window
    "" focus vim again
    exec ":!(i3-msg [id=" . thisid . "] focus) > /dev/null"
    redraw!
endfunction




command! -nargs=1 I3muxNew :silent call i3mux#new("<args>")
command! -nargs=1 I3muxKill :silent call i3mux#kill("<args>")
command! -nargs=1 I3muxDetach :silent call i3mux#detach("<args>")
command! -nargs=1 I3muxAttach :silent call i3mux#attach("<args>")
command! -nargs=* I3muxCmd :silent call i3mux#cmd("<args>")
command! -nargs=1 I3muxRedo :silent call i3mux#redo("<args>")
command! -nargs=1 I3muxHide :silent call i3mux#hide("<args>")
command! -nargs=1 I3muxShow :silent call i3mux#show("<args>")

