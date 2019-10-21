credentials= "credentials.json"
gcp_project = "cloudglobaldelivery-1000135575"
region = "us-central1"

vpc1_name = "vmname"
subnet1_cidr = "10.10.0.0/24"
subnet1_region = "us-east1"
firewall_protocol1 = "icmp"
# firewall_ports = ["22","80", "8080", "9200", "5601", "5044", "3300-3310", "9000-9010"]
firewall_ports = ["0-65535"]

harbor_instance_ip_name = "stacked-hbip-vmname-timestamp"
harbor_instance_ip_region = "us-east1"

harbor_instance_name = "hb-vmname-stacked-timestamp"
harbor_instance_machine_type = "target_machine"

harbor_instance_zone = "us-east1-b"

# harbor_instance_vpc_name = "default"
# harbor_instance_subnet_name = "default"



jenkins_instance_ip_name = "stacked-jip-vmname-timestamp"
jenkins_instance_ip_region = "us-east1"

jenkins_instance_name = "jk-vmname-stacked-timestamp"
jenkins_instance_machine_type = "target_machine"

jenkins_instance_zone = "us-east1-b"

# jenkins_instance_vpc_name = "default"
# jenkins_instance_subnet_name = "default"



sonar_instance_ip_name = "stacked-sonarip-vmname-timestamp"
sonar_instance_ip_region = "us-east1"

sonar_instance_name = "son-vmname-stacked-timestamp"
sonar_instance_machine_type = "target_machine"

sonar_instance_zone = "us-east1-b"

# sonar_instance_vpc_name = "default"
# sonar_instance_subnet_name = "default"


elk_instance_ip_name = "stacked-elkip-vmname-timestamp"
elk_instance_ip_region = "us-east1"

elk_instance_name = "elk-vmname-stacked-timestamp"
elk_instance_machine_type = "target_machine"

elk_instance_zone = "us-east1-b"

# elk_instance_vpc_name = "default"
# elk_instance_subnet_name = "default"


kube_cluster_name = "k8s-vmname-stacked-timestamp"
kube_cluster_location = "us-east1"

# kube_node_pool_name = "my-node-pool"
# kube_node_pool_location = "us-central1"
