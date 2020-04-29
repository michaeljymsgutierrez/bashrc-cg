#! /bin/bash

# removing pavucontrol config
cd ~/ && rm pavucontrol.ini && echo 'DONE: Removing pavucontrol.ini' || echo "FAILED: Removing pavucontrol.ini"
# removing pulse config
cd .config/ && rm -rf pulse/ && echo 'DONE: Removing pulse directory' || echo "FAILED: Removing pulse directory"
# restart pulse and alsa services
echo 'pulseaudio -k && sudo alsa force-reload' | bash

