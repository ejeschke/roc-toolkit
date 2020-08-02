#! /bin/bash
set -euxo pipefail

tar -C "$(brew --cache)" -xvf vendor/bottles/macos-10.13.tar

brew update

brew unlink python@2
brew list |\
    grep -vE 'pkg-config|automake|libtool|cmake|xz|readline|openssl|sqlite|python|gdbm' |\
    xargs brew pin

brew install "scons"
brew install "ragel"
brew install "gengetopt"
brew install "libuv"
brew install "sox"

scons -Q clean

scons -Q \
      --enable-werror \
      --enable-debug \
      --sanitizers=all \
      --build-3rdparty=openfec,cpputest \
      test

scons -Q \
      --enable-werror \
      --build-3rdparty=openfec,cpputest \
      test

scons -Q \
      --enable-werror \
      --build-3rdparty=all \
      test
