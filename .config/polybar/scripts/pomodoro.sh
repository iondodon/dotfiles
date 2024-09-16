#!/bin/bash

while true; do
    # Work for 30 minutes
    sleep 1800  # 1800 seconds = 30 minutes
    
    # Calculate and display time for resuming work
    resume_time=$(date -d "+10 minutes" +"%H:%M")
    
    # Send persistent notification to take a break using Zenity
    zenity --info \
    --title="🛑 Time to Take a Break!" \
    --text="🕑 <b>Rest for 10 minutes.</b>\n⏰ <b>Resume work at:</b> $resume_time" \
    --width=300 \
    --height=100 \
    --ok-label="Got it!" \
    --timeout=0

    # Play a beep sound
    play -v 0.1 -n synth 0.2 sin 1000 fade h 0 0.2 0.1

    # Break for 10 minutes
    sleep 600  # 600 seconds = 10 minutes
    
    # Calculate and display time for the next break
    next_break=$(date -d "+30 minutes" +"%H:%M")
    
    # Send persistent notification to resume work using Zenity
    zenity --info \
    --title="✅ Back to Work!" \
    --text="💼 <b>Time to get back to your tasks.</b>\n🕒 <b>Next break at:</b> $next_break" \
    --width=300 \
    --height=100 \
    --ok-label="OK" \
    --timeout=0

    # Play a beep sound
    play -v 0.1 -n synth 0.2 sin 1000 fade h 0 0.2 0.1
done

