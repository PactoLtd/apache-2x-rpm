
## Build the RPM locally


```sh

> docker -v {PATH_TO_PROJECT}:/apache-2.2-build -ti centos:latest /bin/bash

# clean the project
> cd /apache-2.2-build 
> ./build.sh clean

# compile & compress
> ./buid.sh compile

# publish to nexus
> ./build.sh publish

```

