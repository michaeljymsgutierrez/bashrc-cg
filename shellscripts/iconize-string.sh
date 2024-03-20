#! /bin/bash

raw_window_name="$1"
formatted_window_name=""

convert_string_to_icon() {
  arg="$1"
  lower_case_arg=$(echo "$arg" | tr '[:upper:]' '[:lower:]')
  string="$lower_case_arg"

  if [ $string == '1' ] ; then
    echo "󰬺"
  elif [ $string == '2' ] ; then
    echo "󰬻"
  elif [ $string == '3' ] ; then
    echo "󰬼"
  elif [ $string == '4' ] ; then
    echo "󰬽"
  elif [ $string == '5' ] ; then
    echo "󰬾"
  elif [ $string == '6' ] ; then
    echo "󰬿"
  elif [ $string == '7' ] ; then
    echo "󰭀"
  elif [ $string == '8' ] ; then
    echo "󰭁"
  elif [ $string == '9' ] ; then
    echo "󰭂"
  elif [ $string == '0' ] ; then
    echo "󰬹"
  fi

  if [ $string == 'a' ] ; then
    echo "󰫮"
  elif [ $string == 'b' ] ; then
    echo "󰫯"
  elif [ $string == 'c' ] ; then
    echo "󰫰"
  elif [ $string == 'd' ] ; then
    echo "󰫱"
  elif [ $string == 'e' ] ; then
    echo "󰫲"
  elif [ $string == 'f' ] ; then
    echo "󰫳"
  elif [ $string == 'g' ] ; then
    echo "󰫴"
  elif [ $string == 'h' ] ; then
    echo "󰫵"
  elif [ $string == 'i' ] ; then
    echo "󱂈"
  elif [ $string == 'j' ] ; then
    echo "󰫷"
  elif [ $string == 'k' ] ; then
    echo "󰫸"
  elif [ $string == 'l' ] ; then
    echo "󱎦"
  elif [ $string == 'm' ] ; then
    echo "󱎥"
  elif [ $string == 'n' ] ; then
    echo "󰫻"
  elif [ $string == 'o' ] ; then
    echo "󰬹"
  elif [ $string == 'p' ] ; then
    echo "󰫽"
  elif [ $string == 'q' ] ; then
    echo "󰫾"
  elif [ $string == 'r' ] ; then
    echo "󰫿"
  elif [ $string == 's' ] ; then
    echo "󰬀"
  elif [ $string == 't' ] ; then
    echo "󰬁"
  elif [ $string == 'u' ] ; then
    echo "󰬂"
  elif [ $string == 'v' ] ; then
    echo "󱂌"
  elif [ $string == 'w' ] ; then
    echo "󰬄"
  elif [ $string == 'x' ] ; then
    echo "󱂑"
  elif [ $string == 'y' ] ; then
    echo "󰬆"
  elif [ $string == 'z' ] ; then
    echo "󰬇"
  fi
}

add_dev_icon() {
  arg="$1"
  lower_case_arg=$(echo "$arg" | tr '[:upper:]' '[:lower:]')
  string="$lower_case_arg"

  if [[ $string == *"node"* ]]; then
    echo "󰎙 "
  elif [[ $string == *"git"* ]] ; then
    echo "󰊢 "
  elif [[ $string == *"ember"* ]] ; then
    echo "󰬰 "
  elif [[ $string == *"javascript"* ]] ; then
    echo "󰌞 "
  elif [[ $string == *"note"* ]] ; then
    echo " "
  elif [[ $string == *"vim"* ]] ; then
    echo " "
  elif [[ $string == *"zsh"* ]] ; then
    echo " "
  elif [[ $string == *"src"* ]] ; then
    echo " "
  elif [[ $string == *"srv"* ]] ; then
    echo " "
  fi
}

# formatted_window_name=$(add_dev_icon $raw_window_name)

for (( i=0; i<${#raw_window_name}; i++ )); do
  window_name_value="${raw_window_name:$i:1}"
  formatted_window_name+=$(convert_string_to_icon $window_name_value)
done

echo "$formatted_window_name"

