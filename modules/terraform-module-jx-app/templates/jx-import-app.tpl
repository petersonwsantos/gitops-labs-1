kubectl config set-context `kubectl config current-context` --namespace jx
# application import
rm -rfv ${app_name}/.git
jx import ${app_name} --name='${app_name}' --pack='${app_name}' --git-username=${git_user} --git-provider-url=${git_provider_url} --git-api-token=${git_token} --default-owner=${git_owner}  --org=${git_organization}  --verbose=true --no-draft=true && jx get build log  ${git_organization}/${app_name}/master
# Build
jx start pipeline  ${git_organization}/${app_name}/master && jx get build log ${git_organization}/${app_name}/master
# appplication promote
cd ${app_name}
jx promote --app='${app_name}' --version='0.0.2' --env='staging'     --batch-mode=true
jx promote --app='${app_name}' --version='0.0.2' --env='production'  --batch-mode=true
cd ..