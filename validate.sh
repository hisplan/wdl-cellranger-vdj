#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    CellRangerVdj.wdl \
    --inputs ./configs/test.inputs.aws.json
