# project-hop-in-the-cloud

A **Hop Docker image** supporting both **short-lived** and **long-lived** setups.

## Hop Config

Set HOP_HOME to the `project-a` directory (absolute path) when using Hop locally (on your laptop).

Example:

```
export HOP_HOME=/Users/diethardsteiner/git/project-hop-in-the-cloud/project-a
export HOP_METASTORE_FOLDER=/Users/diethardsteiner/git/project-hop-in-the-cloud/project-a
```

# Running the Container

The container image is available on [Docker Hub](https://hub.docker.com/r/diethardsteiner/project-hop).

## Container Folder Structure


Directory	| Description
---	|---
`/opt/project-hop`	| location of the hop package
`/home/hop`	| here you should mount a directory that contains `.hop` at the root as well your workflows and pipelines.

## Environment Variables

You can provide values for the following environment variables:


Environment Variable	| Description
---	|----
`ENV HOP_LOG_LEVEL`	| Specify the log level. Default: `Basic`. Optional.
`ENV HOP_FILE_PATH`	| Path to hop workflow or pipeline
`ENV HOP_LOG_PATH`	| File path to hop log file
`ENV HOP_RUN_CONFIG`	| Hop run configuration to use
`ENV HOP_RUN_PARAMETERS`	| Parameters that should be passed on to the hop-run command. Specify as comma separated list, e.g. `PARAM_1=aaa,PARAM_2=bbb`. Optional.


## How to run the Container

The most common use case will be that you run a **short-lived container** to just complete one Hop workflow or pipeline.

Example for running a **workflow**:

```bash
docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/home/hop/pipelines-and-workflows/main.hwf \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS=PARAM_TEST=Hello \
  -v /Users/diethardsteiner/git/project-a:/home/hop \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:0.20-20200422.234410-25
```

If you need a **long-lived container**, this option is also available. Run this command e.g.:

```bash
docker run -it --rm \
  -v /Users/diethardsteiner/git/project-a:/home/hop \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:0.20-20200422.234410-25
```

## Shortcomings

- **Metastore**: `HOP_METASTORE_HOME` does not seem to be picked up by Hop. Moreover the Metastore is expected to reside in the default location (`$HOME/.hop/metastore`). Hence it is also not recommended to change `HOP_HOME`. The Metastore is require for the run configuration.
- **Hop Server** is not supported yet.


# Local Development

## How to run the workflow

To just test the workflow locally without Docker:

```
~/apps/hop/hop-run.sh \
  --file=/Users/diethardsteiner/git/project-hop-in-the-cloud/project-a/pipelines-and-workflows/main.hwf \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=2
```

To test the workflow within the **Docker container**:  

```
./hop-run.sh \
  --file=/home/hop/pipelines-and-workflows/main.hwf \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=2
```