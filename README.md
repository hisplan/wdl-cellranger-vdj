# WDLized Cell Ranger V(D)J

## Setup

```bash
aws s3 cp s3://dp-lab-home/software/install-CellRangerVdj-6.0.1.sh - | bash
```

```
$ conda create -n cromwell python=3.7.6 pip
$ pip install cromwell-tools
```

Update `secrets.json` with the new Cromwell Server address:

```bash
$ cat ~/secrets.json
{
    "url": "http://ec2-100-26-170-43.compute-1.amazonaws.com",
    "username": "****",
    "password": "****"
}
```

## Running Workflow

Submit your job:

```bash
conda activate cromwell

./submit.sh \
    -k ~/secrets-aws.json \
    -i config/Lmgp66_tet_replicate.inputs.aws.json \
    -l config/Lmgp66_tet_replicate.labels.aws.json \
    -o CellRangerVdj.options.aws.json
```
