#!/usr/bin/env bash

if [ -z $SCING_HOME ]
then
    echo "Environment variable 'SCING_HOME' not defined."
    exit 1
fi

java -jar ${SCING_HOME}/devtools/womtool.jar \
    validate \
    CellRangerVdj.wdl \
    --inputs ./configs/test.inputs.aws.json
