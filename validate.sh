#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    CellRangerVdj.wdl \
    --inputs ./config/CellRangerVdj.inputs.aws.json
