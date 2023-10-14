#! /usr/bin/env fish
docker run -p 2228:22 --name terribilis-pypy \
       --mount type=bind,source=$HOME/projects/Terribilis-Ludum,target=/home/terribilis/terribilis-ludum \
    --mount type=bind,source=/media/data,target=/home/terribilis/data \
    --mount type=bind,source=$HOME/projects/graeae,target=/home/terribilis/graeae \
    -it terribilis-pypy-official
