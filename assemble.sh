#!/bin/bash

# exit script if one command fails
set -o errexit

# exit script if Variable is not set
set -o nounset

INPUT=/bbx/input/biobox.yml
OUTPUT=/bbx/output
#METADATA=/bbx/metadata

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
IS_DATA_CP=$partis_cacheparameters_isdata
PARAMETER_DIR_CP=$partis_cacheparameters_parameterdir
PLOTDIR_CP=$partis_cacheparameters_plotdir
SEQFILE_CP=$partis_cacheparameters_seqfile
SKIP_UNPRODUCTIVE_CP=$partis_cacheparameters_skipunproductive
N_MAX_QUERIES_CP=$partis_cacheparameters_nmaxqueries
echo "=== parameters read from yaml ==="
echo "CACHE PARAMETERS"
echo $IS_DATA_CP
echo $PARAMETER_DIR_CP
echo $PLOTDIR_CP
echo $SEQFILE_CP
echo $SKIP_UNPRODUCTIVE_CP
echo $N_MAX_QUERIES_CP

#cat Taskfile

echo -n 'default: source ./bin/handbuild.sh && python ./bin/partis.py --action cache-parameters --seqfile ${SEQFILE_CP} --parameter-dir ${PARAMETER_DIR_CP} --plotdir ${PLOTDIR_CP} --n-max-queries ${N_MAX_QUERIES_CP} ' >> ./Taskfile
#cat Taskfile
if [ "$IS_DATA_CP" = true ] ; then
	echo -n '--is-data ' >> ./Taskfile
fi
if [ "$SKIP_UNPRODUCTIVE_CP" = true ] ; then
	echo -n '--skip-unproductive ' >> ./Taskfile
fi
cat Taskfile
echo "XXXXXXXXXXXXX"
echo $(pwd)
ls -l /partis
echo "XXXXXXXXXXXXX"
#if simulate, elif run-viterbi, elif run-forward
if grep -q simulate "$INPUT" ; then
	echo "SIMULATE"
	#statements
	N_MAX_QUERIES_SIM=$partis_simulate_nmaxqueries
	OUTFNAME_SIM=$partis_simulate_outfname
	PARAMETER_DIR_SIM=$partis_simulate_parameterdir
	echo $N_MAX_QUERIES_SIM
	echo $OUTFNAME_SIM
	echo $PARAMETER_DIR_SIM

	echo -n '&& python ./bin/partis.py --action simulate --outfname ${OUTFNAME_SIM} --parameter-dir ${PARAMETER_DIR_SIM} --n-max-queries ${N_MAX_QUERIES_SIM} ' >> ./Taskfile

	
elif grep -q runviterbi "$INPUT" ; then
	#statements
	echo "RUN VITERBI"
	SEQFILE_RV=$partis_runviterbi_seqfile
	IS_DATA_RV=$partis_runviterbi_isdata
	PARAMETER_DIR_RV=$partis_runviterbi_parameterdir
	N_BEST_EVENTS_RV=$partis_runviterbi_nbestevents
	N_MAX_QUERIES_RV=$partis_runviterbi_nmaxqueries
	DEBUG_RV=$partis_runviterbi_debug
	OUTFNAME_RV=$partis_runviterbi_outfname
	PLOTDIR_RV=$partis_runviterbi_plotdir
	PLOTPERFORMANCE_RV=$partis_runviterbi_plotperformance
	echo $SEQFILE_RV
	echo $IS_DATA_RV
	echo $PARAMETER_DIR_RV
	echo $N_BEST_EVENTS_RV
	echo $N_MAX_QUERIES_RV
	echo $DEBUG_RV
	echo $OUTFNAME_RV
	echo $PLOTDIR_RV
	echo $PLOTPERFORMANCE_RV

	echo -n '&& ./bin/partis.py --action run-viterbi --seqfile ${SEQFILE_RV} --parameter-dir ${PARAMETER_DIR_RV} --n-best-events ${N_BEST_EVENTS_RV} --n-max-queries ${N_MAX_QUERIES_RV} --debug ${DEBUG_RV} --outfname ${OUTFNAME_RV} --plotdir ${PLOTDIR_RV} ' >> ./Taskfile
	
	if [ "$IS_DATA_RV" = true ] ; then
		echo -n '--is-data ' >> ./Taskfile
	fi
	if [ "$PLOTPERFORMANCE_RV" = true ] ; then
		echo -n '--plot-performance ' >> ./Taskfile
	fi

elif grep -q runforward "$INPUT" ; then
	#statements
	echo "RUN FORWARD"
	SEQFILE_RF=$partis_runforward_seqfile
	IS_DATA_RF=$partis_runforward_isdata
	PARAMETER_DIR_RF=$partis_runforward_parameterdir
	N_BEST_EVENTS_RF=$partis_runforward_nbestevents
	N_MAX_QUERIES_RF=$partis_runforward_nmaxqueries
	DEBUG_RF=$partis_runforward_debug
	OUTFNAME_RF=$partis_runforward_outfname
	PLOTDIR_RF=$partis_runforward_plotdir
	PLOTPERFORMANCE_RF=$partis_runforward_plotperformance
	echo $SEQFILE_RF
	echo $IS_DATA_RF
	echo $PARAMETER_DIR_RF
	echo $N_BEST_EVENTS_RF
	echo $N_MAX_QUERIES_RF
	echo $DEBUG_RF
	echo $OUTFNAME_RF
	echo $PLOTDIR_RF
	echo $PLOTPERFORMANCE_RF
	
	echo -n '&& ./bin/partis.py --action run-forward --seqfile ${SEQFILERF} --is-data --parameter-dir ${PARAMETER_DIRRF} --n-best-events ${N_BEST_EVENTSRF} --n-max-queries ${N_MAX_QUERIESRF} --debug ${DEBUGRF} --outfname ${OUTFNAMERF} --plotdir ${PLOTDIR_RF} ' >> ./Taskfile

	if [ "$IS_DATA_RF" = true ] ; then
	echo -n '--is-data ' >> ./Taskfile
	fi
	if [ "$PLOTPERFORMANCE_RF" = true ] ; then
		echo -n '--plot-performance ' >> ./Taskfile
	fi
fi
echo "================================="

cat Taskfile

# Use grep to get $TASK in /Taskfile
CMD=$(egrep ^${TASK}: ./Taskfile | cut -f 2 -d ':')
if [[ -z ${CMD} ]]; then
  echo "Abort, no task found for '${TASK}'."
  exit 1
fi

# if /bbx/metadata is mounted create log.txt
#if [ -d "$METADATA" ]; then
#  CMD="($CMD) >& $METADATA/log.txt"
#fi

# Run the given task with eval.
# Eval evaluates a String as if you would use it on a command line.
eval ${CMD}

echo "Process completed"

