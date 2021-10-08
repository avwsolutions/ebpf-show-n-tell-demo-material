#!/bin/bash
NODE=$1
BPF_PROGRAM=$2
export PATH="${PATH}:${HOME}/.krew/bin"
kubectl trace run --serviceaccount=kubectltrace $NODE $BPF_PROGRAM