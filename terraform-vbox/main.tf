terraform {
  required_version = ">1.8.4"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "~> 0.7"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///session"
}

resource "libvirt_pool" "pool" {
  name = "${var.prefix}pool"
  type = "dir"
  target {
    path = "${var.pool_path}${var.prefix}pool" 
    }
}

resource "libvirt_volume" "image" {
  name   = var.image.name
  format = "qcow2"
  pool   = libvirt_pool.pool.name
  source = var.image.url
}

resource "libvirt_volume" "root" {
  name           = "${var.prefix}${count.index + 1}root"
  pool           = libvirt_pool.pool.name
  base_volume_id = libvirt_volume.image.id
  size           = var.vm.disk
  count          = var.vm.count
}

data "template_file" "user_data" {
  count    = var.vm.count
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = "vm-${count.index + 1}"
    ssh_key  = var.ssh_key
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
}

# Cloud-init диски
resource "libvirt_cloudinit_disk" "commoninit" {
  count = var.vm.count
  name  = "commoninit-${count.index + 1}.iso"
  user_data = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config.rendered
}

# Сеть
resource "libvirt_network" "vm_network" {
  name      = "vm-network"
  mode      = "nat"
  addresses = ["192.168.100.0/24"]
  dhcp {
    enabled = true
  }
  dns {
    enabled = true
  }
}

resource "libvirt_domain" "vm" {
  count = var.vm.count
  name   = "${var.prefix}master${count.index + 1}"
  memory = var.vm.ram
  vcpu   = var.vm.cpu

  nvram {
    file = "/var/lib/libvirt/qemu/nvram/${var.prefix}${count.index + 1}master_VARS.fd"
  }
  
  network_interface {
    network_id = libvirt_network.vm_network.id
  }

  disk {
    volume_id = libvirt_volume.root[count.index].id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
  qemu_agent = true
  autostart  = true
}

# Вывод информации о ВМ
output "vm_ips" {
  value = libvirt_domain.vm[*].network_interface[0].addresses
}

output "vm_names" {
  value = libvirt_domain.vm[*].name
}

output "vm_status" {
  value = [for vm in libvirt_domain.vm : "${vm.name} = created"]
}