set -e
# build docker images from dockerfile
docker build -t prepare_fio:1.0 .

# run above built docker image
docker_image_id=`docker images | grep prepare_fio  | grep "1.0" | awk '{printf  $3}'`
docker run $docker_image_id

# show all images
docker images

# show all running images (containers)
docker ps

# Delete all dangling images
docker system prune -f


# Delete specific image
# docker image rm 7ab0bd80ba9c

#run docker
#docker run -v /root/fio_results:/root/fio_results -it ${docker_image_id}  /root/perf/perf_run_remote.sh 192.168.0.17 /dev/sdb ext4 read 90 10
 
