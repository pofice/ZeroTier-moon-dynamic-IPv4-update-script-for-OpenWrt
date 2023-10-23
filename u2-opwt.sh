#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null
then
    echo "jq could not be found"
    echo "Installing jq..."
    opkg update && opkg install jq
fi

/etc/init.d/openclash stop
echo "openclash service stop."

# Set the path to the moon.json file
MOON_JSON_PATH=/etc/config/zero/moon.json

# Get the current public IP address
CURRENT_IP=$(curl -4s https://checkip.amazonaws.com)
echo "Current IP address is: $CURRENT_IP"

# Get the IP address in the moon.json file
MOON_IP=$(jq -r '.roots[0].stableEndpoints[0] | split("/")[0]' $MOON_JSON_PATH)
echo "Moon IP address is: $MOON_IP"

# Check if the IP address has changed
if [ "$CURRENT_IP" != "$MOON_IP" ]; then
  echo "IP is different."
  # Update the IP address in moon.json
  sed -i 's/[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/'"$CURRENT_IP"'/g' moon.json

  # Generate the sign file
  zerotier-idtool genmoon moon.json

  # Delete exsist sign file
  rm -f moons.d/*.moon

  # Move exsist sign file
  mv *.moon moons.d/

  # Restart the zerotier service to apply the changes
  /etc/init.d/zerotier restart
  echo "Zerotier service restart."
fi
echo "IP is same."

/etc/init.d/openclash start
echo "openclash service start."