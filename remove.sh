# ./bin/bash
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
