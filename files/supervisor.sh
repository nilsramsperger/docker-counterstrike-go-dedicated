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
    kill ${!}
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
    echo "Installation done"
}

trap term_handler SIGTERM
[ ! -d "/opt/steam/counterstrike" ] && install
su steam
loadConfig
echo "Starting CS:GO Dedicated Server"
cd /opt/steam/counterstrike
export LD_LIBRARY_PATH="$LD_LIBRABRY_PATH:/opt/steam/counterstrike:/opt/steam/counterstrike/bin"
./srcds_linux -game csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_dust2 +sv_setsteamaccount $GSLT & wait ${!}
echo "Insurgency CS:GO Server died"
shutdown