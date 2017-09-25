#!/bin/bash
docker build -t organiknowledge/shibsp .
docker save -o ../../deploy/dockerimgs/OKshibsp.tar organiknowledge/shibsp
