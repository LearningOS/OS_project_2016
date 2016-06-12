#!/bin/bash

echo 0:
java -jar ../result/decaf.jar -l 0 "$@"

echo
echo 1:
java -jar ../result/decaf.jar -l 1 "$@"

echo
echo 2:
java -jar ../result/decaf.jar -l 2 "$@"
