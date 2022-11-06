#!/bin/bash
# Import VideoDB.zip
unzip VideoDB.zip -d VideoDB
mongorestore -d "video" "VideoDB"