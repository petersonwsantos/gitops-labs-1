kubectl config set-context aws --namespace jx
jx create jenkins token  -p "${admin_password}" ${admin_user} ; jx create git token --name GitHub -t ${git_token} ${git_user}
kubectl delete secret jenkins-docker-cfg
kubectl create secret generic jenkins-docker-cfg --from-file=./config.json
sed -i -e "s|REPLACE_ME_ORG|${git_user}|"  api/charts/preview/Makefile
sed -i -e "s|REPLACE_ME_ORG|${git_user}|"  api/charts/api/Makefile
sed -i -e "s|REPLACE_ME_ORG|${git_user}|"  api/skaffold.yaml
sed -i -e "s|REPLACE_ME_ORG|${git_user}|"  web/charts/preview/Makefile
sed -i -e "s|REPLACE_ME_ORG|${git_user}|"  web/charts/web/Makefile
sed -i -e "s|REPLACE_ME_ORG|${git_user}|"  web/skaffold.yaml