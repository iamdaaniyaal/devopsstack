// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("${var.credentials}")}"
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}


resource "google_compute_network" "vpc1" {
  name                    = "${var.vpc1_name}-vpc"
  auto_create_subnetworks = "false"
}


// Create VPC1 Subnet
resource "google_compute_subnetwork" "subnet1" {
  name          = "${var.vpc1_name}-subnet"
  ip_cidr_range = "${var.subnet1_cidr}"
  network       = "${var.vpc1_name}-vpc"
  depends_on    = ["google_compute_network.vpc1"]
  region        = "${var.subnet1_region}"
}



// VPC 1 INGRESS firewall configuration
resource "google_compute_firewall" "firewall1" {
  name      = "${var.vpc1_name}-ingress-firewall"
  network   = "${google_compute_network.vpc1.name}"
  direction = "INGRESS"

  allow {
    protocol = "${var.firewall_protocol1}"
  }



  allow {
    protocol = "tcp"
    ports    = "${var.firewall_ports}"
  }

  //Giving source ranges as this is a INGRESS Firewall Rule
  source_ranges = ["0.0.0.0/0"]
}

// VPC 1  EGRESS firewall configuration
resource "google_compute_firewall" "firewall2" {
  name               = "${var.vpc1_name}-egress-firewall"
  network            = "${google_compute_network.vpc1.name}"
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "${var.firewall_protocol1}"
  }



  allow {
    protocol = "tcp"
    ports    = "${var.firewall_ports}"
  }

  //Not giving source ranges as this is a EGRESS Firewall Rule
  //source_ranges = "${var.subnet1_source_ranges}"
}


# data "google_compute_image" "harbor" {
#   family  = "centos"
#   project = "cloudglobaldelivery-1000135575"
# }


//Harbor Instance (Ashoks Harbor)

data "google_compute_image" "harbor" {
#   family  = "centos"
  name = "harbor"
  project = "cloudglobaldelivery-1000135575"
}

#resource "google_compute_address" "hbip" {
#  name   = "${var.harbor_instance_ip_name}"
#  region = "${var.harbor_instance_ip_region}"
#}



resource "google_compute_instance" "harbor" {
  name         = "${var.harbor_instance_name}"
  machine_type = "${var.harbor_instance_machine_type}"
  zone         = "${var.harbor_instance_zone}"


  tags = ["name", "harbor", "http-server"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.harbor.self_link}"
    }
  }
  // Local SSD disk
  #scratch_disk {
  #}

  network_interface {
    # network = "default"
    
    network    = "${google_compute_network.vpc1.self_link}"
    subnetwork = "${google_compute_subnetwork.subnet1.self_link}"
    access_config {
      // Ephemeral IP
      #nat_ip       = "${google_compute_address.hbip.address}"
      nat_ip = "35.237.223.92" 
      network_tier = "PREMIUM"
    }
  }



  metadata = {
    name = "harbor"
  }
  #description             = "${google_compute_address.hbip.address}"
  metadata_startup_script = "sudo yum update -y; sudo yum install git -y; export harborip=$(curl -H \"Metadata-Flavor: Google\" http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip);sudo yum install wget -y; sudo sed -i 's/35.185.35.12/'$harborip'/gI' /opt/harbor/harbor.yml; cd /opt/harbor/; sudo systemctl restart docker;sudo ./install.sh --with-clair"


  service_account {
    email  = "newjarvis@cloudglobaldelivery-1000135575.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  # metadata_startup_script = "sudo yum update; sudo yum install wget -y; sudo  echo \"root123\" | passwd --stdin root; sudo  mv /etc/ssh/sshd_config  /opt; sudo touch /etc/ssh/sshd_config; sudo echo -e \"Port 22\nHostKey /etc/ssh/ssh_host_rsa_key\nPermitRootLogin yes\nPubkeyAuthentication yes\nPasswordAuthentication yes\nUsePAM yes\" >  /etc/ssh/sshd_config; sudo systemctl restart  sshd;sudo useradd test; sudo echo  -e \"test    ALL=(ALL)  NOPASSWD:  ALL\" >> /etc/sudoers;"
}



//Jenkins Instance

data "google_compute_image" "jenkins" {
#   family  = "centos"
  #name = "jenkins-image-dev"
  name = "jenkins-jarvis-build-image"
  project = "cloudglobaldelivery-1000135575"
}

resource "google_compute_address" "jip" {
  name   = "${var.jenkins_instance_ip_name}"
  region = "${var.jenkins_instance_ip_region}"
}

# data "template_file" "mydeamon" {
#   # template = "${file("conf.wp-config.php")}"

#   template = templatefile("${path.module}/mydeamon.json", { jenkinsip = "${google_compute_address.jenkinsip.address}" })

# }

resource "google_compute_instance" "jenkins" {
  name         = "${var.jenkins_instance_name}"
  machine_type = "${var.jenkins_instance_machine_type}"
  zone         = "${var.jenkins_instance_zone}"

  tags        = ["name", "jenkins", "http-server"]
  #description = "xxxxxx+${google_compute_address.hbip.address}+${google_container_cluster.primary.name}"

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.jenkins.self_link}"
    }
  }

  // Local SSD disk
  #scratch_disk {
  #}


  network_interface {
    network    = "${google_compute_network.vpc1.self_link}"
    subnetwork = "${google_compute_subnetwork.subnet1.self_link}"

    access_config {
      // Ephemeral IP

      nat_ip       = "${google_compute_address.jip.address}"
      network_tier = "PREMIUM"
    }
  }





  metadata = {
    name = "jenkins"
  }


  
  metadata_startup_script = "sudo yum update -y; sudo yum install git -y; mkdir xyz; cd xyz; sudo git clone https://github.com/iamdaaniyaal/devopsstack.git; cd devopsstack; sudo chmod 777 *.*; sudo sh task.sh;"

  service_account {
    email  = "newjarvis@cloudglobaldelivery-1000135575.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }




}


//SonarQube Instance
data "google_compute_image" "sonarqube" {
#   family  = "centos"
  name = "sonarqube"
  project = "cloudglobaldelivery-1000135575"
}


#resource "google_compute_address" "sonarip" {
#  name   = "${var.sonar_instance_ip_name}"
#  region = "${var.sonar_instance_ip_region}"
#}

data "google_compute_address" "sonarvmip" {
	name = "sonarqubeip-jarvis"
	project = "cloudglobaldelivery-1000135575"
}

resource "google_compute_instance" "sonarqube" {
  name         = "${var.sonar_instance_name}"
  machine_type = "${var.sonar_instance_machine_type}"
  zone         = "${var.sonar_instance_zone}"

  tags = ["name", "sonarqube", "http-server"]

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.sonarqube.self_link}"
    }
  }

  // Local SSD disk
  #scratch_disk {
  #}

  network_interface {
    network    = "${google_compute_network.vpc1.self_link}"
    subnetwork = "${google_compute_subnetwork.subnet1.self_link}"


    access_config {
      // Ephemeral IP
      nat_ip = "34.75.218.241"
    }
  }
  metadata = {
    name = "sonarqube"
  }

  metadata_startup_script = "sudo yum update -y;sudo yum install git -y; sudo su; systemctl restart mysqld; sh /opt/sonarqube/bin/linux-x86-64/sonar.sh start;"
}



//ELK

# data "google_compute_image" "elk" {
# #   family  = "centos"
#   name = "elk"
#   project = "cloudglobaldelivery-1000135575"
# }

resource "google_compute_address" "elkip" {
  name   = "${var.elk_instance_ip_name}"
  region = "${var.elk_instance_ip_region}"
}


resource "google_compute_instance" "elk" {
  name         = "${var.elk_instance_name}"
  machine_type = "${var.elk_instance_machine_type}"
  zone         = "${var.elk_instance_zone}"

  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20190816"
    }
  }

  // Local SSD disk
#   scratch_disk {
#   }

  network_interface {
    # network = "default"
     network    = "${google_compute_network.vpc1.self_link}"
    subnetwork = "${google_compute_subnetwork.subnet1.self_link}"


    access_config {
      // Ephemeral IP

      nat_ip       = "${google_compute_address.elkip.address}"
      network_tier = "PREMIUM"
    }
  }

  #metadata = {
  # foo = "bar"
  #}

  metadata_startup_script = "sudo apt-get update; sudo apt-get install git -y; sudo echo 'export ip='$(hostname -i)'' >> ~/.profile; source ~/.profile; echo \"export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64\" >>/etc/profile; echo \"export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin\" >>/etc/profile; source /etc/profile; mkdir chandu; cd chandu; sudo apt-get install wget -y; git clone https://github.com/iamdaaniyaal/devopsstack.git; cd devopsstack; sudo chmod 777 elk.sh; sh elk.sh"





}


//Kubernetes

resource "google_container_cluster" "primary" {
  #name     = "${var.kube_cluster_name}"
  name = "cluster"
  location = "${var.kube_cluster_location}"
     network    = "${google_compute_network.vpc1.self_link}"
    subnetwork = "${google_compute_subnetwork.subnet1.self_link}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
#   remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

# resource "google_container_node_pool" "primary_preemptible_nodes" {
#   name       = "${var.kube_node_pool_name}"
#   location   = "${var.kube_node_pool_location}"
#   cluster    = "${google_container_cluster.primary.name}"
#   node_count = 1

#   node_config {
#     preemptible  = true
#     machine_type = "n1-standard-1"

#     metadata = {
#       disable-legacy-endpoints = "true"
#     }

#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#     ]
#   }
# }
