resource "oci_core_instance" "ubuntu-vm" {
  compartment_id      = var.compartment_ocid
  display_name        = "ubuntu-vm"
  availability_domain = var.availability_domain
  shape               = "VM.Standard.E2.2"

  source_details {
    source_type = "image"
    source_id   = var.ubuntu_image_ocid
  }

  create_vnic_details {
    subnet_id        = var.subnet_ocid
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("${path.module}/script.sh"))
  }
}

output "instance_public_ip" {
  value       = oci_core_instance.ubuntu-vm.public_ip
  description = "IP pública de la VM"
}

output "instance_id" {
  value       = oci_core_instance.ubuntu-vm.id
  description = "ID de la VM"
}