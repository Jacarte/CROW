#!/bin/sh

name=$(echo $1 | sed 's/\.[^.]*$//')
ext=$(echo $1 | sed 's/^.*\.//')

# export BINARYEN_DEBUG_SOUPERIFY=0

if [ "${ext}" == "wast" ]; then
  echo "### step1 wast2wasm \c"
  ../../wabt/bin/wat2wasm ${name}.wast -o ${name}.wasm
  ext='wasm'
  echo "okay"
fi

if [ "${ext}" == "wasm" ]; then
  echo "### step2 wasm2c \c"
  ../../wabt/bin/wasm2c ${name}.wasm -o ${name}.c
  ext='c'
  echo "okay"
fi

if [ "${ext}" == "c" ]; then
  echo "### step3 c2ll \c"
  clang --target=wasm32 -nostdlib -emit-llvm -S ${name}.c
  ext='ll'
  echo "okay"
fi

if [ "${ext}" == "ll" ]; then
  echo "### step4 ll2bc \c"
  llvm-as ${name}.ll
  ext='bc'
  echo "okay"
fi

if [ "${ext}" == "bc" ]; then
  echo "### step5 bc2opt2ll \c"
  sh bc2opt2ll.sh ${name}.bc ../../souper/build/souper
  ext='ll'
  echo "okay"
fi

# echo "### extra ll2s \c"
# llc -march=wasm32 -filetype=asm ${name}.ll
# echo "okay"

# echo "### extra ll2o \c"
# llc -march=wasm32 -filetype=obj ${name}.ll
# echo "okay"
