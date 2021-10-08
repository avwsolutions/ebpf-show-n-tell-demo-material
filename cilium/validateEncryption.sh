#!/bin/bash

kubectl -n kube-system exec -ti ds/cilium -- bash

# apt update -y
# apt install tcpdump -y

# tcpdump -n -i eth0 esp

