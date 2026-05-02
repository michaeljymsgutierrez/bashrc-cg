#! /bin/bash

connecting_icon=$(shuf -e 󰤟  󰤢  󰤥  -n 1)
connected_icon=$(shuf -e  󰤡  󰤤  󰤧  -n 1)
disconnected_icon=$(shuf -e 󰤠  󰤣  󰤦  -n 1)

echo "#[fg=#f8f1ff,bg=#222222,bold]$connecting_icon #[fg=#f8f1ff,bg=#222222,bold]󰫶󰫻"

if ping -c 2 google.com > /dev/null ; then
  echo "#[fg=#fde466,bg=#222222,bold]$connected_icon #[fg=#f8f1ff,bg=#222222,bold]󰫰󰫻"
else
  echo "#[fg=#fa618d,bg=#222222,bold]$disconnected_icon #[fg=#f8f1ff,bg=#222222,bold]󰫱󰫰"
fi
