#!/bin/bash

# exit script if one command fails
set -o errexit

# exit script if Variable is not set
set -o nounset

INPUT=/bbx/input/biobox.yml
OUTPUT=/bbx/output
METADATA=/bbx/metadata

# Since this script is the entrypoint to your container
# you can access the task in `docker run task` as the first argument
TASK=$1

# Ensure the biobox.yaml file is valid
# TBD

mkdir -p ${OUTPUT}
# =====================================
# Parse the yaml file, read partis subparameters
# include parse_yaml function
. parse_yaml.sh 
# read yaml file
eval $(parse_yaml $INPUT "partis_")

# Access yaml content
# get parameters for "cache-parameters"
IS_DATA=$partis_cacheparameters_isdata
PARAMETER_DIR=$partis_cacheparameters_parameterdir
PLOTDIR=$partis_cacheparameters_plotdir
SEQFILE=$partis_cacheparameters_seqfile
SKIP_UNPRODUCTIVE=$partis_cacheparameters_skipunproductive
echo "=== parameters read from yaml ==="
echo "CACHE PARAMETERS"
echo $IS_DATA
echo $PARAMETER_DIR
echo $PLOTDIR
echo $SEQFILE
echo $SKIP_UNPRODUCTIVE
#if simulate, elif run-viterbi, elif run-forward
if grep -q simulate "$INPUT" ; then
	#statements
	N_MAX_QUERIES=$partis_simulate_nmaxqueries
	OUTFNAME=$partis_simulate_outfname
	SIM_PARAMETER_DIR=$partis_simulate_parameterdir
	echo $N_MAX_QUERIES
	echo $OUTFNAME
	echo $SIM_PARAMETER_DIR
	# cat << EOF > ${OUTPUT}/biobox.yml
	# 	project: bioboxpartis
	# 	action: simulate
	# 	output file name: ${OUTFNAME}
	# EOF
elif grep -q runviterbi "$INPUT"; then
	#statements
	SEQFILERV=$partis_runviterbi_seqfile
	IS_DATARV=$partis_runviterbi_isdata
	PARAMETER_DIRRV=$partis_runviterbi_parameterdir
	N_BEST_EVENTSRV=$partis_runviterbi_nbestevents
	N_MAX_QUERIESRV=$partis_runviterbi_nmaxqueries
	DEBUGRV=$partis_runviterbi_debug
	OUTFNAMERV=$partis_runviterbi_outfname
	echo $SEQFILERV
	#echo $IS_DATARV
	echo $PARAMETER_DIRRV
	echo $N_BEST_EVENTSRV
	echo $N_MAX_QUERIESRV
	echo $DEBUGRV
	echo $OUTFNAMERV
	# cat << EOF > ${OUTPUT}/biobox.yml
	# 	project: bioboxpartis
	# 	action: runviterbi
	# 	output file name: ${OUTFNAMERV}
	# EOF
elif grep -q runforward "$INPUT"; then
	#statements
	SEQFILERF=$partis_runforward_seqfile
	IS_DATARF=$partis_runforward_isdata
	PARAMETER_DIRRF=$partis_runforward_parameterdir
	N_BEST_EVENTSRF=$partis_runforward_nbestevents
	N_MAX_QUERIESRF=$partis_runforward_nmaxqueries
	DEBUGRF=$partis_runforward_debug
	OUTFNAMERF=$partis_runforward_outfname
	echo $SEQFILERF
	echo $IS_DATARF
	echo $PARAMETER_DIRRF
	echo $N_BEST_EVENTSRF
	echo $N_MAX_QUERIESRF
	echo $DEBUGRF
	echo $OUTFNAMERF
	# cat << EOF > ${OUTPUT}/biobox.yml
	# 	project: bioboxpartis
	# 	action: runforward
	# 	output file name: ${OUTFNAMERF}
	# EOF
# else 
# 	cat << EOF > ${OUTPUT}/biobox.yml
#                 project: bioboxpartis
#                 action: default
#         EOF
fi
echo "================================="

#Create a boolean dictionary to process boolean parameters
#IS_DATA, SKIP_UNPRODUCTIVE, 

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

echo "Process completed"

