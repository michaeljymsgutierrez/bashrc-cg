#!/bin/bash

echo "#[fg=#f8f1ff,bg=#222222,bold]󰌚 #[fg=#f8f1ff,bg=#222222,bold]󰫶󰫻"

if ping -c 2 google.com > /dev/null ; then
  echo "#[fg=#fde466,bg=#222222,bold]󰌘 #[fg=#f8f1ff,bg=#222222,bold]󰫰󰫻"
else
  echo "#[fg=#fa618d,bg=#222222,bold]󰌙 #[fg=#f8f1ff,bg=#222222,bold]󰫱󰫰"
fi
