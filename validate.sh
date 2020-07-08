#!/usr/bin/env bash

java -jar ~/Applications/womtool.jar \
    validate \
    CellRangerVdj.wdl \
    --inputs ./config/Lmgp66_tet_replicate.inputs.aws.json
