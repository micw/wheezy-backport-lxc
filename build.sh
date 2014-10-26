#!/bin/bash

rm -rf target; mkdir target
docker build -t wheezy-backport-lxc . && docker run -v $( pwd )/target:/target wheezy-backport-lxc
