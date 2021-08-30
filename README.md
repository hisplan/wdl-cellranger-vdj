# wdl-cellranger-vdj

WDLized Cell Ranger V(D)J Pipeline

## Setup

The pipeline is a part of SCING (Single-Cell pIpeliNe Garden; pronounced as "sing" /siŋ/). For setup, please refer to [this page](https://github.com/hisplan/scing). All the instructions below is given under the assumption that you have already configured SCING in your environment.

## Create Job Files

You need two files for processing a V(D)J sample - one inputs file and one labels file. Use the following example files to help you create your configuration file:

- `config/template.inputs.json`
- `config/template.labels.json`

### Inputs

Note that the prefix `CellRangerVdj.` is omitted for brevity.

- `referenceGenome`
  - Specify a reference to be used:
    - `GRCh38`: Human
    - `GRCm38`: Mouse
- `chain`
  - Force the analysis to be carried out for a particular chain type. The accepted values are:
    - `auto`: autodetection based on TR vs. IG representation
    - `TR`: T cell receptors
    - `IG`: B cell receptors

## Submit Your Job

```bash
conda activate scing

./submit.sh \
    -k ~/keys/cromwell-secrets.json \
    -i configs/sample.inputs.json \
    -l configs/sample.labels.json \
    -o CellRangerVdj.options.aws.json
```
