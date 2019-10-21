variable "credentials" {}
variable "gcp_project" {}
variable "region" {}

variable "vpc1_name" {}
variable "subnet1_cidr" {}
variable "subnet1_region" {}
variable "firewall_protocol1" {}
variable "firewall_ports" {
  type = list(string)
}


variable "harbor_instance_ip_name" {}
variable "harbor_instance_ip_region" {}
variable "harbor_instance_name" {}
variable "harbor_instance_machine_type" {}
variable "harbor_instance_zone" {}
# variable "harbor_instance_vpc_name" {}
# variable "harbor_instance_subnet_name" {}

variable "jenkins_instance_ip_name" {}
variable "jenkins_instance_ip_region" {}
variable "jenkins_instance_name" {}
variable "jenkins_instance_machine_type" {}
variable "jenkins_instance_zone" {}
# variable "jenkins_instance_vpc_name" {}
# variable "jenkins_instance_subnet_name" {}


variable "sonar_instance_ip_name" {}
variable "sonar_instance_ip_region" {}
variable "sonar_instance_name" {}
variable "sonar_instance_machine_type" {}
variable "sonar_instance_zone" {}
# variable "sonar_instance_vpc_name" {}
# variable "sonar_instance_subnet_name" {}


variable "elk_instance_ip_name" {}
variable "elk_instance_ip_region" {}
variable "elk_instance_name" {}
variable "elk_instance_machine_type" {}
variable "elk_instance_zone" {}
# variable "elk_instance_vpc_name" {}
# variable "elk_instance_subnet_name" {}

variable "kube_cluster_name" {}
variable "kube_cluster_location" {}

# variable "kube_node_pool_name" {}
# variable "kube_node_pool_location" {}
