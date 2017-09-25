#!/bin/bash
docker build -t organiknowledge/nginxshib .
docker save -o ../../deploy/dockerimgs/OKnginxshib.tar organiknowledge/nginxshib
