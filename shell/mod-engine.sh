#!/bin/bash -x

# cml_ns="cdp-cxy-cml-1"
cml_ns="$1"

[ -z "$cml_ns" ] && echo 'Error: Must provide CML namespace!' && exit 1

while sleep 2; do
    for i in $( kubectl get ns -l ds-parent-namespace="$cml_ns" --no-headers -o custom-columns=":metadata.name" ); do
        kubectl -n "$i" get networkpolicies -o yaml | kubectl delete -f -
        kubectl -n "$i" get ingresses --no-headers -o custom-columns=":metadata.name" | \
            xargs -tI % kubectl -n "$i" annotate ingress % kubernetes.io/ingress.class=haproxy --overwrite
    done
done