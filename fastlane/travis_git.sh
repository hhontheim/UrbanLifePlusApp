#!/bin/bash

git config --global user.email "travis@travis-ci.com"
git config --global user.name "Travis CI"

git remote add travis https://${GH_TOKEN}@github.com/hhontheim/UrbanLifePlusApp.git > /dev/null 2>&1