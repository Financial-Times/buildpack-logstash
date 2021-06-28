buildpack-logstash
==================

# FT NAR LANTERN - Buildpack to grab logstash workflow

Steps taken to automate the bundle of buildpack-logstash

The detailed process steps below describes expected workflow.


## Prerequisites
1. **Setup environment variables for Dockerfile** amazon_es_local, jsqs_local, project_directory, test_file

## Process
1. Build image - image is created with logstash bundled with plugins and rspec
2. Create container - from the image build, create a container by running the image
3. Copy files - make a copy of the container files and store locally

## Detailed Process Steps

### 1. Build docker image for buildpack logstash
```
$ ./build.sh
```
### 2. Build a container from the created image
```
$ docker run -i -t addplugins:dockerfile /bin/bash
```
### 3. Copy logstash files from container to local machine.
```
i) Get container id by opening another terminal and running
$ docker ps

ii)
$ docker cp <containerId>:/logstash /host/path/target
```

### 4. Optionally zip folder
```
$ tar -cvzf logstash.tar.gz logstash
```

### 5. Optionally upload to s3
