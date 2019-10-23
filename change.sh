sudo sed -i 's/stacked/'$stack'/gI' terraform.tfvars
export time=$(date +"%m%d%y%H%M%S")
sudo sed -i 's/timestamp/'$time'/gI' terraform.tfvars
sudo sed -i 's/vmname/'$stack_name'/gI' terraform.tfvars
sudo sed -i 's/target_machine/'$machine_type'/gI' terraform.tfvars


terraform init
terraform plan
terraform apply --auto-approve



# if [ $stack==devops ]
# then
# export jenkins=jk-'$stack-name'-'$stack'-'$time'
export jenkins='jk-'$stack_name'-'$stack'-'$time''
export jkip=`gcloud compute instances list --filter="name='$jenkins'" --format "get(networkInterfaces[0].accessConfigs[0].natIP)"`
echo $jkip; 
echo "curl -X POST http://"$jkip":8080/job/Gk8/build --user jenkins:jenkins"
# curl -X POST http://"$jkip":8080/job/Gk8/build --user jenkins:jenkins
# fi
# export jenkins=jk-'$stack-name'-'$stack'-'$time'

# export ip=`gcloud compute instances list --filter="name='$jenkins'" --format "get(networkInterfaces[0].accessConfigs[0].natIP)"`
# echo $ip
# curl -X POST http://'$ip':8080/job/Gk8/build --user jenkins:jenkins
