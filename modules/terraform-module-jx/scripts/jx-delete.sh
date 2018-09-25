kubectl config set-context aws --namespace jx

if `helm list &>  /dev/null`; then
    for h in `helm list | grep -v ^NAME | awk '{print $1}'`
    do
        helm delete $h --purge && echo "Deleted helm $h "
    done
    helm reset --force
fi

for ns in `kubectl get ns | grep ^jx | awk '{print $1}'`
do
    services=$(kubectl get svc --namespace $ns)
    if [ "$services" != '' ]; then
        for svc in `kubectl get svc --namespace $ns | awk '{print $1}' | grep -v ^NAME`
        do
            kubectl delete svc $svc --namespace $ns &&  echo "Deleted service $svc from namespace $ns"
        done
    fi
    kubectl delete ns $ns && echo "Deleted namespace $ns"
done

exit_configmap_jenkins_jx_role_binding=$(kubectl get clusterrolebindings | grep ^jenkins-jx-role-binding | awk '{print $1}')

if [ "$exit_configmap_jenkins_jx_role_binding" != '' ]; then  kubectl delete clusterrolebindings $(kubectl get clusterrolebindings | grep ^jenkins-jx-role-binding | awk '{print $1}') ; fi

exit_configmap_gc_previews=$(kubectl get clusterrolebindings | grep ^gc-previews | awk '{print $1}')

if [ "$exit_configmap_gc_previews" != '' ]; then  kubectl delete clusterrolebindings $(kubectl get clusterrolebindings | grep ^gc-previews | awk '{print $1}') ; fi

exit_configmap_gc_previews=$(kubectl get clusterroles        | grep ^gc-previews | awk '{print $1}')

if [ "$exit_configmap_gc_previews" != '' ]; then  kubectl delete clusterroles  $(kubectl get clusterroles        | grep ^gc-previews | awk '{print $1}') ; fi

exit_configmap_ingress_controller_leader_nginx=$(kubectl get configmaps --namespace kube-system | grep ^ingress-controller-leader-nginx | awk '{print $1}')

if [ "$exit_configmap_ingress_controller_leader_nginx" != '' ]; then  kubectl delete configmaps --namespace kube-system $(kubectl get configmaps --namespace kube-system | grep ^ingress-controller-leader-nginx      | awk '{print $1}') ; fi

exit_configmap_jenkins_x=$(kubectl get configmaps --namespace kube-system | grep ^jenkins-x | awk '{print $1}')

if [ "$exit_configmap_jenkins_x" != '' ]; then  kubectl delete configmaps --namespace kube-system $(kubectl get configmaps --namespace kube-system | grep ^jenkins-x | awk '{print $1}') ; fi

exit_configmap_dev=$(kubectl get configmaps --namespace kube-system | grep ^jx-development | awk '{print $1}')

if [ "$exit_configmap_dev" != '' ]; then  kubectl delete configmaps --namespace kube-system $(kubectl get configmaps --namespace kube-system | grep ^jx-development  | awk '{print $1}') ; fi

exit_configmap_stg=$(kubectl get configmaps --namespace kube-system | grep ^jx-staging | awk '{print $1}')

if [ "$exit_configmap_stg" != '' ]; then  kubectl delete configmaps --namespace kube-system $(kubectl get configmaps --namespace kube-system | grep ^jx-staging      | awk '{print $1}') ; fi

exit_configmap_prd=$(kubectl get configmaps --namespace kube-system | grep ^jx-production | awk '{print $1}')

if [ "$exit_configmap_prd" != '' ]; then  kubectl delete configmaps --namespace kube-system $(kubectl get configmaps --namespace kube-system | grep ^jx-production   | awk '{print $1}') ; fi

unset exit_configmap_dev
unset exit_configmap_stg
unset exit_configmap_prd
unset exit_configmap_jenkins_x
unset exit_configmap_ingress_controller_leader_nginx
unset exit_configmap_gc_previews
unset exit_configmap_jenkins_jx_role_binding

if `ls ~/.jx   &>  /dev/null` ; then rm ~/.jx   -rf && echo -e "\033[1;36m Deleted ~/.jx  "; fi

if `ls ~/.helm &>  /dev/null` ; then rm ~/.helm -rf && echo -e "\033[1;36m Deleted ~/.Helm"; fi