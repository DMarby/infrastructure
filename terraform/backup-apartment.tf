resource "vsphere_virtual_machine" "backup-apartment" {
  name             = "backup-apartment"
  tags             = [vsphere_tag.backup.id]
  resource_pool_id = vsphere_compute_cluster.apartment_cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.esxi-apartment.id

  num_cpus = 2
  memory   = 2048
  guest_id = data.vsphere_virtual_machine.ubuntu-18_04.guest_id

  network_interface {
    network_id     = vsphere_distributed_port_group.apartment_servers.id
    adapter_type   = data.vsphere_virtual_machine.ubuntu-18_04.network_interface_types[0]
    use_static_mac = true
    mac_address    = "00:50:56:a7:40:c1"
  }

  disk {
    label = "disk0"
    size  = 750
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu-18_04.id

    customize {
      network_interface {
      }

      linux_options {
        host_name = "backup-apartment"
        domain    = "home.dmarby.se"
      }
    }
  }
  # Prevent terraform from recreating VMs when we update the template
  lifecycle {
    ignore_changes = [clone.0.template_uuid, disk.0]
  }
}

