variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ubuntu_image_ocid" {
  description = "ocid de la imagen para ubuntu 20.04"
}
variable "ssh_public_key" {
  description = "contenido de la llave publica para ssh"
}
variable "subnet_ocid" {
  description = "The OCID of the subnet"
}
variable "availability_domain" {
  description = "The availability domain where the resources will be created"
}