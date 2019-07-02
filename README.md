# Counterstrike Global Offensive dedicated server
This image provides a plain CS:GO dedicated server.

# Attention! This is work in progress and not ready for use!

## System Requirements
The server is not contained by the image, to keep it small.
It will download and install on first start of the container.
You will need at least **20GB** of HDD space, for the container to inflate.

## Create a GSLT (Game Server Login Token)
To start a CS:GO dedicated server, you need to get a GSLT from Valve first.
Go to https://steamcommunity.com/dev/managegameservers to start the process.
The game ID for CS:GO is 730.
The token has to be used in the `docker run` command in the following section.

## Usage
Start a new container with the following command.

`docker run -d --init --name csgo-dedicated --restart unless-stopped -e PORT=27015 -e GSLT=xxx -v csgo-config:/var/csgo/cfg -p 27015:27015 -p 27015:27015/udp nilsramsperger/counterstrike-go-dedicated`

* Replace the `xxx` for your GSLT
* The server will be available on port 27015.
You can change `-e PORT=27015` it as you like.

## Troubleshooting
### Question
The installation fails with the message: `Error! App '740' state is 0x202 after update job.`
### Answer
Your server lacks the needed HDD space for installation.