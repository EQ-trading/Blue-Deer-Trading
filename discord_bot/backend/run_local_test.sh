#!/bin/bash

export LOCAL_TEST=true
export DISCORD_TOKEN=MTA3OTg5NzQzNjYzMTM1MTMyNg.Gg1pFG.KMvaVS2lB_ckad7kiY-HZjfTtemFTbwC4GiR6s
export TEST_TOKEN=MTA3OTg5NzQzNjYzMTM1MTMyNg.Gg1pFG.KMvaVS2lB_ckad7kiY-HZjfTtemFTbwC4GiR6s

# Change to the directory containing the app
cd "$(dirname "$0")"

# Run the Discord bot
python3 run_bot.py