#!/bin/bash

# Switch to the user before running the ownership changes
chown -R $USER:$GROUP /app/satisfactory-vol

chown -R $USER:$GROUP /home/lorris/.config/Epic/FactoryGame/Saved/SaveGames

# Make the script executable
chmod +x /app/satisfactory-vol/FactoryServer.sh


log_dir="/app/satisfactory-vol/FactoryGame/Saved/Logs/"

# Redirect stdout to multiple log files
for log_file in "$log_dir"/*.log; do
  exec > >(tee -a "$log_file") 2>&1
done
# Rest of your entrypoint script
#/app/satisfactory-vol/FactoryServer.sh -Port=25565 -NOSTEAM

# Switch to the user before running the command
gosu $USER:$GROUP /app/satisfactory-vol/FactoryServer.sh -Port=25565 -NOSTEAM

chown -R $USER:$GROUP /home/lorris/.config/Epic/FactoryGame/Saved/SaveGames
