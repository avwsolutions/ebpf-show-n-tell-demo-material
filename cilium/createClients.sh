#!/bin/bash
kubectl run ahold --image=radial/busyboxplus:curl -i --tty -n sock-shop
kubectl run curl --image=radial/busyboxplus:curl -i --tty -n sock-shop
#kubectl exec ahold -it  -n sock-shop -- sh