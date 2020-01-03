#!/bin/sh -e
#TODO -e is not documented as valid option, what is this supposed to do?
set -x

################################################################################
# This program and the accompanying materials are made available under the terms of the
# Eclipse Public License v2.0 which accompanies this distribution, and is available at
# https://www.eclipse.org/legal/epl-v20.html
#
# SPDX-License-Identifier: EPL-2.0
#
# Copyright IBM Corporation 2019
################################################################################

SCRIPT_NAME=$(basename "$0")
CURR_PWD=$(pwd)

# if KEEP_TEMP_FOLDER is true, catchall-packaging.sh won't be executed.
# remove data sets, unless build option requested to keep temp stuff
if [ -f cleanup-smpe-packaging-datasets.txt ]; then
  for dsprefix in $(cat cleanup-smpe-packaging-datasets.txt); do
    if [ -n "${dsprefix}" ]; then
      echo "[${SCRIPT_NAME}] deleting ${dsprefix}.** ..."
      datasets=$(${CURR_PWD}/smpe/bld/get-dsn.rex "${dsprefix}.**" || true)
      # rc is always 0, but error message has blanks while DSN list does not
      for dsn in $datasets
      do
        if [ -n "$(echo $dsn | grep ' ')" ]; then
          echo "[${SCRIPT_NAME}][error] $dsn"                     # variable holds error message
          # exit 1
        elif [ -n "${dsn}" ]; then
          # delete data sets
          tsocmd "DELETE '$dsn'" || true
        fi
      done    # for dsn
      echo "[${SCRIPT_NAME}] - done"
    fi
  done
fi
