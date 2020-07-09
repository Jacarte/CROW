#! /bin/bash

PROGRAM=$1


SOURCE=$(dirname $(realpath $BASH_SOURCE))
PROGRAM_DIR=$(dirname $(realpath $PROGRAM))
PROGRAM_NAME=$(basename $(realpath $PROGRAM))

echo docker run -it --rm -v $PROGRAM_DIR:/inputs -v $SOURCE/crow:/slumps/crow -v $(pwd)/crow_out:/slumps/crow/out  -v $(pwd)/logs:/slumps/crow/logs --entrypoint /bin/bash jacarte/slumps:crow 

docker run -it --rm -v $PROGRAM_DIR:/inputs -v $SOURCE/crow:/slumps/crow -v $(pwd)/crow_out:/slumps/crow/crow/out  -v $(pwd)/logs:/slumps/crow/crow/logs --entrypoint /bin/bash jacarte/slumps:crow