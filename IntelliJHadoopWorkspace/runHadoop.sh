#!/bin/bash
su -c hadoop
start-dfs.sh
start-yarn.sh
jps
