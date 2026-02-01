#!/bin/bash
SESSION="ppluk"

# Create session if it doesn't exist
tmux has-session -t "$SESSION" 2>/dev/null
if [ $? != 0 ]; then
  # First create the session + first window ("Home")
  tmux new-session -d -s "$SESSION" -c "$HOME" -n "Home"

  # user-interface
  tmux new-window -t "$SESSION:" -c "$HOME/ppluk/usage-hub-user-interface" -n "user-interface"
  tmux send-keys  -t "$SESSION:user-interface" "npm run dev" C-m

  # localstack
  tmux new-window -t "$SESSION:" -c "$HOME/ppluk/usage-hub-application-interface" -n "localstack"
  tmux send-keys  -t "$SESSION:localstack" "docker compose -f localstack-compose.yaml up" C-m

  # application-interface
  tmux new-window -t "$SESSION:" -c "$HOME/ppluk/usage-hub-application-interface" -n "application-interface"
fi

# Optional: start on Home
tmux select-window -t "$SESSION:Home"

# Attach
tmux attach -t "$SESSION"
