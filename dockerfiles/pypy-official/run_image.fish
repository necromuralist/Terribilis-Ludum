#! /usr/bin/env fish
docker run -p 2228:22 --name terribilis-pypy-official \
       --mount type=bind,source=$HOME/projects/terribilis-ludum,target=/home/terribilis/terribilis-ludum \
       --mount type=bind,source=/media/data,target=/home/terribilis/data \
       -itterribilis-pypy-official
