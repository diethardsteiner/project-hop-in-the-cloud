#!/bin/bash
####################################################################### 
# "PROJECT_STARTUP_JOB"
# path to Kettle job from within volume
#
# "KETTLE_LOG_LEVEL"
# values are [Basic / Debug] 
#######################################################################


BASENAME="${0##*/}"

# Standard function to print an error and exit with a failing return code 
error_exit () {
  echo "${BASENAME} - ${1}" >&2
  exit 1 
}

# retrieve files from volume
# ... done via Dockerfile via specifying a volume ... 



if [ -z "${HOP_FILE_PATH}" ]
then
  echo "=== >> === >> === >> === >> === >> === >> === >> === >> === >> === >> "
  echo "Since no file name was provided, we will start a long-lived process."
  echo "=== >> === >> === >> === >> === >> === >> === >> === >> === >> === >> "
  /bin/bash
else
  # Run main job
  ${DEPLOYMENT_PATH}/hop/hop-run.sh \
    --file=${HOP_FILE_PATH} \
    --runconfig=${HOP_RUN_CONFIG} \
    --level=${HOP_LOG_LEVEL} \
    --parameters=${HOP_RUN_PARAMETERS} \
    2>&1 | tee ${HOP_LOG_PATH}
fi
  