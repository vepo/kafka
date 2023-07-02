#!/bin/bash

cd ..
docker build . -t vepo/kafka:3
cd -
docker-compose up