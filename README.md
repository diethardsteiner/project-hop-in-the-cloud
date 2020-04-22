# project-hop-in-the-cloud

## Hop Config

Set HOP_HOME to the `project-a` directory (absolute path) when using Hop locally (on your laptop).

Example:

```
export HOP_HOME=/Users/diethardsteiner/git/project-hop-in-the-cloud/project-a
export HOP_METASTORE_FOLDER=/Users/diethardsteiner/git/project-hop-in-the-cloud/project-a
```

# Running the Container

## Container Folder Structure


Directory	| Description
---	|---
`/opt/project-hop`	| location of the hop package
`/home/hop`	| here you should mount a directory that contains `.hop` as well your workflows and pipelines.

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


Example for running a **workflow**:

```
docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/home/hop/pipelines-and-workflows/main.hwf \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS=PARAM_TEST=Hello \
  -v /Users/diethardsteiner/git/project-a:/home/hop \
  --name my-simple-hop-container \
  diethardsteiner/hop:0.10
```

## Shortcomings

- **Metastore**: `HOP_METASTORE_HOME` does not seem to be picked up by Hop. Moreover the Metastore is expected to reside in the default location (`$HOME/.hop/metastore`). Hence it is also not recommended to change `HOP_HOME`. The Metastore is require for the run configuration.