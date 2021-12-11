
variable "aws_access_key" {
}
variable "aws_secret_key" {
}

variable "region" {
  default = "eu-south-1"
}

#############################################################################

# My domain name which is hosted on AWS Route 53 
# look at ENVIRONMENT_CNAME variable definition, in terraform TF_VAR_VARIABLE is a shell env variable \
# that you can fetch and put it as terraform variable, I used this in main.tf

#############################################################################


variable "ENVIRONMENT_CNAME" {
  type        = string
  description = "This is an example input variable using env variables."
}


variable "private_key_path" {
  default = "~/.ssh/nasri.pem"
}
variable "private_key" {
  default = "nasri"
}

variable "network_address_space" {
  default = "10.1.0.0/16"
}
variable "subnet1_network_space" {
  default = "10.1.0.0/24"

}
variable "subnet2_network_space" {
  default = "10.1.1.0/24"

}



variable "billing_code_tag" {

  default = "AWX-Project1"
}
variable "environment_tag" {
  default = "dev"
}
variable "ansible_dynamic_tag" {
  default = "dynamic_group"

}



#### congifuring Network #### 
variable "network_info" {

  default = "10.0.0.0/8"


}


### create ami map #### 
variable "ami-map" {
  type = map(string)
  default = {
    us-east-1 = "ami-1234"
    us-east-2 = "ami-5649"

  }
}
ami = lookup(var.ami-map, "us-east-2")

variable "subnet_count" {
  default = 2
}
