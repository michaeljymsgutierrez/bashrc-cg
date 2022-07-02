#! /bin/bash
# Shell script for switching ssh-id

cd ~/.ssh && ls -d */

echo "Switching ssh started..."

if [ $@ == "foo" ]
then
  rm ~/.ssh/id_rsa && rm ~/.ssh/id_rsa.pub && rm known_hosts && rm known_hosts.old
  cp ~/.ssh/chaelgutierrez/id_rsa ~/.ssh/ && cp ~/.ssh/chaelgutierrez/id_rsa.pub ~/.ssh/
  git config --global user.name "foo"
  git config --global user.email "foo@gmail.com"
  echo "Switching ssh done..."
elif [ $@ == "bar" ]
then
  rm ~/.ssh/id_rsa && rm ~/.ssh/id_rsa.pub && rm known_hosts && rm known_hosts.old
  cp ~/.ssh/mikebacayo/id_rsa ~/.ssh/ && cp ~/.ssh/mikebacayo/id_rsa.pub ~/.ssh/
  git config --global user.name "bar"
  git config --global user.email "bar@gmail.com"
  echo "Switching ssh done..."
fi

cat ~/.gitconfig

eval "$(ssh-agent -s)"

ssh -T git@github.com
