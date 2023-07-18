#!/bin/sh

redis-server &
node main.js --listen host=0.0.0.0
