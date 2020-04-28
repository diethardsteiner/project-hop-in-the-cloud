FROM openjdk:8-alpine
MAINTAINER Diethard Steiner
# path to where the artefacts should be deployed to
ENV DEPLOYMENT_PATH=/opt/project-hop
# parent directory in which the hop config artefacts live
# ENV HOP_HOME= ... left to default for now since metastore has to be in default location
# path to hop metastore
# ENV HOP_METASTORE_FOLDER= ... not supported for now
# specify the hop log level
ENV HOP_LOG_LEVEL=Basic
# path to hop workflow or pipeline e.g. ~/project/main.hwf
ENV HOP_FILE_PATH=
# file path to hop log file, e.g. ~/hop.err.log
ENV HOP_LOG_PATH=$DEPLOYMENT_PATH/hop.err.log
# hop run configuration to use
ENV HOP_RUN_CONFIG=
# parameters that should be passed on to the hop-run command
# specify as comma separated list, e.g. PARAM_1=aaa,PARAM_2=bbb
ENV HOP_RUN_PARAMETERS=

# Define en_US.
# ENV LANGUAGE en_US.UTF-8 => Why is this required? Setting the env var only and not using
# it via update-local will not do anything or?
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
# ENV LC_CTYPE en_US.UTF-8 => why is this needed if LC_ALL is set?
# ENV LC_MESSAGES en_US.UTF-8 => why is this needed if LC_ALL is set?



# ENV HOP_JAVA_HOME=$JAVA_HOME 
# not available yet, see https://project-hop.atlassian.net/browse/HOP-204
# OPTIONAL
# The “-XX:+AggressiveHeap” tells the container to use all memory assigned to the container. 
# this removed the need to calculate the necessary heap Xmx
# ENV HOP_JAVA_OPTIONS=-XX:+AggressiveHeap => HOP_JAVA_OPTIONS doesn't exist you
# https://project-hop.atlassian.net/browse/HOP-208

# INSTALL REQUIRED PACKAGES AND ADJUST LOCALE
# procps: The package includes the programs ps, top, vmstat, w, kill, free, slabtop, and skill

RUN apk update \
  && apk add --no-cache bash curl procps \ 
  && rm -rf /var/cache/apk/* \
  && mkdir ${DEPLOYMENT_PATH} \
  && adduser -D -s /bin/bash -h /home/hop hop \
  && chown hop:hop ${DEPLOYMENT_PATH}

#   && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
#   && locale-gen \
#   && update-locale LANG=${LANG} LC_ALL={LC_ALL} \



# copy the hop package from the local resources folder to the container image directory
COPY --chown=hop:hop ./resources/ ${DEPLOYMENT_PATH}

# make volume available so that hop pipeline and workflow files can be provided easily
# this one should also include the .pod config
VOLUME ["/home/hop"]
USER hop
ENV PATH=$PATH:${DEPLOYMENT_PATH}/hop
WORKDIR /home/hop
ENTRYPOINT ["/opt/project-hop/load-and-execute.sh"]