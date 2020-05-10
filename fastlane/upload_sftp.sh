#!/bin/bash

cp ../build/manifest.plist .

url="<li><a href=\"itms-services://?action=download-manifest&url=https://hontheim.net/deploy/ulp/$1/manifest.plist\">$1</a></li>"
ipa="https:\/\/hontheim.net\/deploy\/ulp\/$1\/app.ipa"

sed -i '' "s/url_to_replace/$ipa/g" ./manifest.plist
sed -i '' "s/UrbanLifePlusApp/UrbanLife+/g" ./manifest.plist

echo $url > append_on_server

ssh hontheim.net@ssh.strato.de "mkdir hontheim/hontheim/deploy/ulp/$1"

scp ./append_on_server hontheim.net@ssh.strato.de:hontheim/hontheim/deploy/ulp/append_on_server
scp ./manifest.plist hontheim.net@ssh.strato.de:hontheim/hontheim/deploy/ulp/$1
scp ../build/app.ipa hontheim.net@ssh.strato.de:hontheim/hontheim/deploy/ulp/$1

# ssh hontheim.net@ssh.strato.de "rm hontheim/hontheim/deploy/ulp/latest"
# ssh hontheim.net@ssh.strato.de "ln -s $1/ hontheim/hontheim/deploy/ulp/latest"

ssh hontheim.net@ssh.strato.de "rm hontheim/hontheim/deploy/ulp/latest/manifest.plist"
ssh hontheim.net@ssh.strato.de "ln -s ../$1/manifest.plist hontheim/hontheim/deploy/ulp/latest/manifest.plist"

ssh hontheim.net@ssh.strato.de "cat hontheim/hontheim/deploy/ulp/append_on_server >> hontheim/hontheim/deploy/ulp/index.html"
ssh hontheim.net@ssh.strato.de "rm hontheim/hontheim/deploy/ulp/append_on_server"

rm ./append_on_server
rm ./manifest.plist

exit 0
