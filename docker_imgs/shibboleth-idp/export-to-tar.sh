#!/bin/bash
docker build -t organiknowledge/shibboleth-idp .
docker save -o ../../deploy/dockerimgs/OKshibidp.tar organiknowledge/shibboleth-idp
