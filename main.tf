provider "google" {
  credentials = "/var/lib/jenkins/.config/gcloud/credentials/terraform.json"
  #credentials = "${file("C:/Users/imachine/.config/gcloud/credentials/terraform.json ")}"
  project     = "terraformproject-253815"
  region      = "us-central1"
  zone        = "us-central1-f"
}


#resource "google_compute_firewall" "allow-database" {  
#    name = "allow-database"
#    network =  "default"
#    allow {
#        protocol = "tcp"
#        ports = ["3306","27017","5432"]
#    }
#
#    source_ranges = ["10.0.0.0/8"]
#    target_tags = ["database"]
#}
#
#
#resource "google_compute_firewall" "allow-apps" {  
#    name = "allow-apps"
#    network =  "default"
#    allow {
#        protocol = "tcp"
#        ports = ["80","8080", "8081","8084","8083","8088"]
#    }
#
#    source_ranges = ["0.0.0.0/0"]
#    target_tags = ["apps"]
#}

#resource "google_compute_address" "apps-ip" {
#    name         = "apps-ip"
#    subnetwork   = "default"
#    address_type = "INTERNAL"
#    address      = "10.156.15.101"
#    #region       = "us-central1"
#}
#resource "google_compute_address" "database-ip" {
#    name         = "database-ip"
#    subnetwork   = "default"
#    address_type = "INTERNAL"
#    address      = "10.156.15.102"
#    #region       = "us-central1"
#}

resource "google_compute_instance" "docker" {
	count         = "${var.instance_count}" 
  
    name         = "${element(var.instance_name, count.index)}"
  
	machine_type = "n1-standard-1"


	boot_disk {
		initialize_params{
			size  = "10"
      type  = "pd-ssd"
      image = "centos-7-v20190905"
		}
	}

    network_interface {
        network = "default"
        network_ip = "${element(var.instance_ip, count.index)}"
        access_config {
                
        }
    }
    metadata = { ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key ["${var.ssh_user}"])}" }

    tags = [ "${element(var.instance_name, count.index)}" ]
}