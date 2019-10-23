sudo echo 'export jenkinsip=`curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip`' >> ~/.bash_profile
source ~/.bash_profile
sudo echo 'export ipdata=`curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/description`' >> ~/.bash_profile
source ~/.bash_profile

export sonarqubeip=$(cut -d + -f 1 <<< $ipdata)
export harborip=$(cut -d + -f 2 <<< $ipdata)
export cluster=$(cut -d + -f 3 <<< $ipdata)
source ~/.bash_profile

cd /var/lib/jenkins/jobs/Gk8
sudo sed -i 's/35.243.237.117/'$harborip'/gI' config.xml
sudo sed -i 's/k8s-stack-devopsstack-101819104711/'$cluster'/gI' config.xml
#sudo sed -i 's/https://github.com/ashoksanem/jenkins_test/'

cd /
cd /var/lib/jenkins

sudo sed -i 's/34.74.131.185/'$sonarqubeip'/gI' hudson.plugins.sonar.SonarGlobalConfiguration.xml
sudo sed -i 's/35.185.111.135/'$jenkinsip'/gI' jenkins.model.JenkinsLocationConfiguration.xml


sudo systemctl restart jenkins

cd /
cd /etc/docker

sudo sed -i 's/35.243.237.117/'$harborip'/gI' daemon.json
sudo systemctl restart docker

cat > /opt/ipvalue.txt << EOF
harbor_target

EOF

sudo sed -i 's/harbor_target/'$harborip'/'  /opt/ipvalue.txt

echo "$harborip" > /opt/hbip.txt
