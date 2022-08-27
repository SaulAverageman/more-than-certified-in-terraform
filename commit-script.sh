#!/bin/bash
ssh-agent bash -c "ssh-add ../id_rsa; git pull"
git add .
git commit -m "`date`"
var=`hostname`
if [ ${var:0:1} = 'n' ]
  then
    ssh-agent bash -c "ssh-add ../id_rsa; git push -u origin main"
  else
    git push -u origin main
fi

echo "Done and dusted!"
sleep 2
