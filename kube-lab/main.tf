terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu+ssh://reika@192.168.1.5/system"
}

resource "libvirt_domain" "kvm_vm" {
  name = var.vm_name
  memory = var.memory * 1024 # Memory in MB
  vcpu = var.vcpu

  disk {
    volume_id = "${var.vm_name}-disk"
  }

  network_interface {
    bridge = "bridge0" # Replace with your bridge name
  }

  disk {
    file = "/tank/software/iso/nixos-gnome-24.11.710050.62c435d93bf0-x86_64-linux.iso"
  }

  graphics {
    type        = "spice"  # Or "spice" if you have spice-vdagent installed
    #listen      = "0.0.0.0" # Listen on all interfaces (for testing, restrict in production)
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  cloudinit = libvirt_cloudinit_disk.config.id # For cloud-init configuration (see below)
}

resource "libvirt_volume" "kvm_disk" {
  name = "${var.vm_name}-disk"
  pool = "default" # Or your storage pool name
  size = var.disk_size * 1024 * 1024 * 1024 # Size in bytes
}

resource "libvirt_cloudinit_disk" "config" {
  name = "kvm-cloud-init"
  user_data = filebase64("./cloud-init.cfg") # Path to your cloud-init config
}

