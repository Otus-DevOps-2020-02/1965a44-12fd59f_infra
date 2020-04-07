#!/bin/sh
gcloud beta compute instances create reddit-app \
--zone=europe-west1-d --machine-type=f1-micro \
--preemptible --restart-on-failure \
--tags=puma-server \
--image-family=reddit-full --boot-disk-size=10GB
