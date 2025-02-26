#!/bin/bash

set -e

if ! command -v pnpm &> /dev/null
then
    apt-get update && apt-get install --no-install-recommends -y -q curl ca-certificates

    # Install volta
    bash -c "$(curl -fsSL https://get.volta.sh)" -- --skip-setup
    export VOLTA_HOME="${HOME}/.volta"
    export PATH="${VOLTA_HOME}/bin:${PATH}"

    volta install node@20.12.2
    volta install pnpm@9.0.6
fi

pnpm install --frozen-lockfile
pnpm build:all

## dist
DIST_DIR="./public/dist"
rm -rf ${DIST_DIR} && mkdir -p ${DIST_DIR}
cp -r ./ui/artalk/dist/{Artalk.css,Artalk.js} ${DIST_DIR}
cp -r ./ui/artalk/dist/{ArtalkLite.css,ArtalkLite.js} ${DIST_DIR}

I18N_DIR="${DIST_DIR}/i18n"
mkdir -p ${I18N_DIR}
cp -r ./ui/artalk/dist/i18n/*.js ${I18N_DIR}

## sidebar
SIDEBAR_DIR="./public/sidebar"
rm -rf ${SIDEBAR_DIR} && mkdir -p ${SIDEBAR_DIR}
cp -r ./ui/artalk-sidebar/dist/* ${SIDEBAR_DIR}

## plugins
PLUGIN_DIR="${DIST_DIR}/plugins"
mkdir -p ${PLUGIN_DIR}

pnpm build:auth
cp -r ./ui/plugin-auth/dist/artalk-plugin-auth.js ${PLUGIN_DIR}
