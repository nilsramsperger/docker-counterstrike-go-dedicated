#!/usr/bin/env bash

loadConfig() {
    echo "Loading config"
    yes | cp -rfa /var/csgo/cfg/. /opt/steam/counterstrike/csgo/cfg/
}

storeConfig() {
    echo "Storing config"
    yes | cp -rfa /opt/steam/counterstrike/csgo/cfg/. /var/csgo/cfg/
}

shutdown() {
    pkill srcds_linux
    storeConfig
    echo "Container stopped"
    exit 143;
}

term_handler() {
    echo "SIGTERM received"
    shutdown
}

install() {
    echo "Installing CS:GO Dedicated Server"
    /opt/steam/steamcmd.sh +login anonymous +force_install_dir /opt/steam/counterstrike +app_update 740 validate +quit
    chown -R steam:steam /opt/steam/counterstrike
    ln -s /opt/steam/linux32 /home/steam/.steam/sdk32
    echo "Installation done"
}

update() {
    echo "Updating CS:GO Dedicated Server"
    /opt/steam/steamcmd.sh +login anonymous +app_update 740 +quit
    echo "Update done"
}

trap term_handler SIGTERM
[ ! -d "/opt/steam/counterstrike" ] && install || update
loadConfig
echo "Starting CS:GO Dedicated Server"
cd /opt/steam/counterstrike
export LD_LIBRARY_PATH=/opt/steam/counterstrike:/opt/steam/counterstrike/bin:${LD_LIBRARY_PATH}
su steam -c "./srcds_linux -game csgo -autoupdate -console -usercon -port $PORT +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $GSLT" & wait ${!}
echo "CS:GO Server died"
shutdown