#!/bin/bash
# set -x
# set -e
if [[ "" != "$1" ]]; then
    export JAVA_HOME=$1
fi
CR_DIR=./cr_test_hello
rm -rf $CR_DIR Test.class
$JAVA_HOME/bin/javac Test.java || exit 1
$JAVA_HOME/bin/java -XX:CRaCCheckpointTo=$CR_DIR Test || echo Checkpoint completed
$JAVA_HOME/bin/java -XX:CRaCRestoreFrom=$CR_DIR #>1.log 2>&1

