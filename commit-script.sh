#!/bin/bash
ssh-agent bash -c "ssh-add ../id_rsa; git pull"
git add .
git commit -m "`date`"
ssh-agent bash -c "ssh-add ../id_rsa; git push -u origin main"

echo "Done and dusted!"
sleep 2