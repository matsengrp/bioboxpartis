#!/bin/bash

# exit script if one command fails
set -o errexit

# exit script if Variable is not set
set -o nounset

#INPUT=/bbx/input/biobox.yml
INPUT=/bbx/input/biobox.yml
OUTPUT=/bbx/output
METADATA=/bbx/metadata

# Since this script is the entrypoint to your container
# you can access the task in `docker run task` as the first argument
TASK=$1

# Ensure the biobox.yaml file is valid
# TBD

mkdir -p ${OUTPUT}

# Parse the yaml file, read partis subparameters

# include parse_yaml function
. parse_yaml.sh
 
# read yaml file
eval $(parse_yaml $INPUT "partis_")
 
# access yaml content

IS_DATA=$partis_cacheparameters_isdata
PARAMETER_DIR=$partis_cacheparameters_parameterdir
PLOTDIR=$partis_cacheparameters_plotdir
SEQFILE=$partis_cacheparameters_seqfile
SKIP_UNPRODUCTIVE=$partis_cacheparameters_skipunproductive

N_MAX_QUERIES=$partis_simulate_nmaxqueries
OUTFNAME=$partis_simulate_outfname
SIM_PARAMETER_DIR=$partis_simulate_parameterdir

echo "=== parameters read from yaml ==="
echo $IS_DATA
echo $PARAMETER_DIR
echo $PLOTDIR
echo $SEQFILE
echo $SKIP_UNPRODUCTIVE

echo $N_MAX_QUERIES
echo $OUTFNAME
echo $SIM_PARAMETER_DIR
echo "================================="

# Use grep to get $TASK in /Taskfile
CMD=$(egrep ^${TASK}: /Taskfile | cut -f 2 -d ':')
if [[ -z ${CMD} ]]; then
  echo "Abort, no task found for '${TASK}'."
  exit 1
fi

# if /bbx/metadata is mounted create log.txt
if [ -d "$METADATA" ]; then
  CMD="($CMD) >& $METADATA/log.txt"
fi

# Run the given task with eval.
# Eval evaluates a String as if you would use it on a command line.
eval ${CMD}


cat << EOF > ${OUTPUT}/biobox.yaml
arguments:
  - csv:
    - id: partis_test
      value: simulate.csv
      type: csv
EOF

