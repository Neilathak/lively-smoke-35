#!/usr/bin/env bash

DIALOG='\033[0;36m' 
WARNING='\033[0;31m'
LINKY='\033[0;41m'
NC='\033[0m'

echo -n -e "${DIALOG}What Region? [us-south1/2/3 and us-east1/2/3 currently] ${NC}  "
read -r LOCATION
  
echo -n -e "${DIALOG}What OS? [ulatest = UBUNTU_LATEST_64, u16, u18, win16] ${NC}  "
read -r OSCHOICE

echo -n -e "${DIALOG}What Flavor?:\n - micro = B1_1X2X100\n - small = B1_2X4X100\n - medium = B1_8X16X100\n - large = B1_16X32X100 ${NC}  "
read -r FLAVOR

echo -e "\n${DIALOG}Deploying ${OSCHOICE}-${FLAVOR} virual instance[s] to ${LOCATION} ${NC}  "

sed -i '' "s|LOCATION|$LOCATION|g" ./main.tf
sed -i '' "s|OSCHOICE|$OSCHOICE|g" ./main.tf
sed -i '' "s|FLAVOR|$FLAVOR|g" ./main.tf