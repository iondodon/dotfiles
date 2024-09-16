#!/bin/bash

while true; do
    # Work for 30 minutes
    sleep 1800  # 1800 seconds = 30 minutes
    
    # Calculate time for resuming work
    resume_time=$(date -d "+10 minutes" +"%H:%M")
    
    # Ask if the user wants to take a break or snooze for 10 minutes
    zenity --question \
    --title="🛑 Time to Take a Break!" \
    --text="🕑 <b>Rest for 10 minutes.</b>\n⏰ <b>Resume work at:</b> $resume_time\n\nDo you want to snooze for 10 more minutes?" \
    --width=300 --height=150
    
    if [ $? -eq 1 ]; then
        # Snooze for 10 minutes if user chooses 'Cancel' (which is equivalent to 'Snooze')
        sleep 600
    fi
    
    # Play a beep sound after the initial or snoozed time
    play -v 0.1 -n synth 0.2 sin 1000 fade h 0 0.2 0.1
    
    # Break for 10 minutes
    sleep 600  # 600 seconds = 10 minutes
    
    # Calculate time for the next break
    next_break=$(date -d "+30 minutes" +"%H:%M")
    
    # Ask if the user wants to resume work or snooze for 10 minutes
    zenity --question \
    --title="✅ Back to Work!" \
    --text="💼 <b>Time to get back to your tasks.</b>\n🕒 <b>Next break at:</b> $next_break\n\nDo you want to snooze for 10 more minutes?" \
    --width=300 --height=150
    
    if [ $? -eq 1 ]; then
        # Snooze for 10 minutes if user chooses 'Cancel' (which is equivalent to 'Snooze')
        sleep 600
    fi
    
    # Play a beep sound after the initial or snoozed time
    play -v 0.1 -n synth 0.2 sin 1000 fade h 0 0.2 0.1
done

