variable "name" {
    description = "Name of the resourcen."
    default     = "demo1"
}

variable "zone" {
  description = "The zone that the machine should be created in"
  default     = "europe-west3-c"    
} 

variable "environment" {
    description = "Environment for service"
    default     = "Stage5"
}

variable "description" {
    description = "An optional description."
    default     = ""
}

variable "size" {
    description = "Size of the persistent disk."
    default     = "10" 
}

variable "type" {
    description = "URL disk."
    default     = "pd-ssd"
}

variable "image" {
    description = "The image from which to initialize this disk."
    default     = "centos-7"
}
variable "ssh_user" {
    description = "The ."
    default     = "jenkins"
}
variable "ssh_pub_key" {
    type = "map"
    description = "The ."
    default = {
        "imgcp" = "~/.ssh/imgcp.pub"
        "jenkins" = "~/.ssh/jenkins.pub"
    }    
}
variable "ssh_key" {
    description = "The."
    default     = "~/.ssh/jenkins"
}
variable "instance_name" {
    type = list(string)
    description = "The ."
    default = ["db", "app"]    
}

variable "instance_ip" {
    type = list(string)
    description = "The ."
    default = ["10.156.15.201", "10.156.15.202"]    
}


variable "instance_count" {
  default = "2"
}