#!/bin/bash
attemptsMax=100
aCnt=0
export KUBECONFIG=~/workspace/kubeup/kubeconfig.conf
while [ "${aCnt}" -lt "${attemptsMax}" ]; do
    echo "Run $aCnt"
    
    # Create pvc
    kubectl apply -f pvc.yaml

    # Wait until created.
    cnt=0
    while [[ "$(kubectl get pvc px-shared-pvc | grep Bound |wc -l)" -eq 0 ]]; do
        if [ "${cnt}" -gt "30" ]; then
            echo "pvc status:"
            kubectl describe pvc
            echo >&2 "Failure!"
            exit 1
        fi
        echo "$(date +%H:%M:%S)" "waiting for pvc creation. Attempt #${cnt}"
        cnt=$((cnt + 1))
        sleep 10   
    done


    # Create pods
    sleep 1
	kubectl apply -f mysql.yaml

    # Wait until created.
    cnt=0
    while [ "$(kubectl get pods -l app=mysql | grep 'Running' -c)" -lt "3" ]; do
        if [ "${cnt}" -gt "30" ]; then
            echo "pod status:"
            kubectl describe pods -l app=mysql
            echo >&2 "Failure!"
            exit 1
        fi
        echo "$(date +%H:%M:%S)" "waiting for pod creation. Attempt #${cnt}"
        cnt=$((cnt + 1))
        sleep 10   
    done

    # Delete pods
    kubectl delete -f mysql.yaml

    # Wait until pods deleted.
    cnt=0
    while [[ "$(kubectl get pods -l app=mysql | wc -l)" -gt "0" ]]; do
        if [ "${cnt}" -gt "30" ]; then
            echo "pod status:"
            kubectl describe pods -l app=mysql
            echo >&2 "Failure!"
            exit 1
        fi
        echo "$(date +%H:%M:%S)" "waiting for pod deletion. Attempt #${cnt}"
        cnt=$((cnt + 1))
        sleep 10   
    done
    
    # delete pvc
    kubectl delete -f pvc.yaml

    # Wait until pvc deleted.
    cnt=0
    while [[ "$(kubectl get pvc | grep px-shared-pvc | wc -l)" -gt "0" ]]; do
        if [ "${cnt}" -gt "30" ]; then
            echo "pvc status:"
            kubectl describe pvc
            echo >&2 "Failure!"
            exit 1
        fi
        echo "$(date +%H:%M:%S)" "waiting for pvc deletion. Attempt #${cnt}"
        cnt=$((cnt + 1))
        sleep 10   
    done

    aCnt=$((aCnt + 1))
done
