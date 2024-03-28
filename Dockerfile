FROM ubuntu

ENV GROUP=satisfactory_group
ENV USER=lorris
ENV USER_UID=1001
ENV GROUP_GID=1002
ENV MC_DIR=/app
ENV SteamAppId=526870

# Creating a new custom group and a new system user
RUN groupadd -g $GROUP_GID $GROUP && \
    useradd -u $USER_UID -g $GROUP_GID -d /home/$USER -m -s /bin/bash $USER

# Add the user to the group
RUN usermod -aG $GROUP $USER

# Create the target directory and give ownership to the user
RUN mkdir -p $MC_DIR && \
    chown -R $USER:$GROUP $MC_DIR && \
    chmod -R 770 $MC_DIR


# Install required packages
RUN apt update && \
    apt install -y wget unzip libicu-dev

# Install xdg-user-dirs
RUN apt-get update && \
    apt-get install -y xdg-user-dirs

RUN apt-get update && apt-get install -y gosu
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libc6:i386 libstdc++6:i386 libgcc1:i386 libncurses5:i386 lib32z1 libbz2-1.0:i386


WORKDIR $MC_DIR

COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

RUN mkdir -p /home/lorris/.steam/sdk64
RUN mkdir -p /home/lorris/.config/Epic/FactoryGame/Saved/SaveGames

RUN chown -R $USER:$GROUP $MC_DIR && \
    chmod -R 770 /home/lorris/.steam/sdk64

# Download DepotDownloader
RUN wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_2.5.0/DepotDownloader-linux-x64.zip
RUN unzip DepotDownloader-linux-x64.zip
RUN chmod +x DepotDownloader
#install satisfactory server sdk
#RUN ./DepotDownloader -app 1690800 -depot 1690802 -manifest 4427727108828296404

# Install steam sdk
RUN ./DepotDownloader -app 90 -depot 1006 -manifest 4884950798805348056

# Copy steamclient.so with proper permissions
RUN cp -rf /app/depots/1006/12778849/linux64/steamclient.so /home/lorris/.steam/sdk64/steamclient.so

RUN chown -R $USER:$GROUP /home/lorris/.steam
RUN chown -R $USER:$GROUP /home/lorris/.config

# Switch to the user before running commands
EXPOSE 15777
EXPOSE 15000
EXPOSE 25565

USER root

ENTRYPOINT [ "./entrypoint.sh" ]
