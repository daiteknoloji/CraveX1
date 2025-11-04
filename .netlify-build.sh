#!/bin/bash
# Netlify pre-build script - Python dependencies'i skip et

# requirements.txt'i geçici olarak kaldır
if [ -f requirements.txt ]; then
    mv requirements.txt requirements.txt.bak
    echo "requirements.txt geçici olarak requirements.txt.bak olarak yeniden adlandırıldı"
fi

# Element Web build
cd www/element-web
yarn install
yarn build

# requirements.txt'i geri getir (cleanup)
if [ -f ../requirements.txt.bak ]; then
    mv ../requirements.txt.bak ../requirements.txt
fi

