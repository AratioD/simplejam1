#!/bin/bash

unit_run_dir=$(perl -e 'use File::Basename; use Cwd "abs_path"; print dirname(abs_path(@ARGV[0]));' -- "$0")
export PRODUCT_DIR=$(cd $unit_run_dir/../.. ; echo `pwd`)

cd $PRODUCT_DIR
npm install && npm install -y npx
npx netlify-cms-proxy-server

while [ 1 -ne 0 ]
do
    sleep 10
done
