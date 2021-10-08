#!/bin/bash
helm upgrade --install falco falcosecurity/falco --set ebpf.enabled=true --namespace falco