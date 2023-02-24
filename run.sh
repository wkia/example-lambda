set -x
(cd ../crac/ && \
	sudo cp ~/work/criu/criu/criu ./build/linux-x86_64-server-release/images/jdk/lib && \
	sudo chown root:root ./build/linux-x86_64-server-release/images/jdk/lib/criu && \
	sudo chmod u+s ./build/linux-x86_64-server-release/images/jdk/lib/criu) \
	|| exit 1

sudo rm -rf cr jdk || exit 1
#docker container prune -f
docker image rm crac-lambda-checkpoint
docker system prune -f

./crac-steps.sh s00_init || exit 1
bash ./crac-steps.sh dojlink ~/work/crac/build/linux-x86_64-server-release/images/jdk || exit 1
./crac-steps.sh s01_build || exit 1
set +x 
echo ">>>>>>> To trigger a checkpoint run './crac-steps.sh s03_checkpoint' from another terminal window"
set -x
(sleep 1; ./crac-steps.sh s03_checkpoint)&
./crac-steps.sh s02_start_checkpoint
sleep 1
./crac-steps.sh s04_prepare_restore
set +x
echo ============================================================================================
# bash -x ./crac-steps.sh steps "local_test -v /home:/home -w $PWD ubuntu dd if=../data of=/dev/null"
# bash -x ./crac-steps.sh steps "make_cold_local" "local_test -v /home:/home -w $PWD ubuntu dd if=../data of=/dev/null"
echo ==== Starting RESTORE...
echo ">>>>>>> To trigger a restore run './crac-steps.sh post hi' from another terminal window"
set -x
(sleep 3; ./crac-steps.sh post hi | tee received.log; sleep 3; docker container stop `docker container ls -q`)&
rm -f 1.log
sudo rm -f /dev/shm/*
./crac-steps.sh steps make_cold_local
./crac-steps.sh s05_local_restore >1.log
cat 1.log
set +x
grep '"hi"' received.log && echo PASSED || (echo !!! FAILED !!! && exit 1)
