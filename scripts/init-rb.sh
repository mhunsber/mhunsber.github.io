#!/usr/bin/env bash

PROJECT_ROOT="$(dirname "$(dirname "$(realpath "$0")")")"
source "$HOME/.rvm/scripts/rvm"
rvm use "$(cat ${PROJECT_ROOT}/.ruby-version)" --install;
