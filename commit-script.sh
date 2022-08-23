#!/bin/bash
git add .
git commit -m "`date`"
ssh-agent bash -c "ssh-add ../id_rsa; git push -u origin main"
sleep 30