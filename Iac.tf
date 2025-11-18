 provider "google" {
    project = "siva-477505" 
    credentials = file("/var/lib/jenkins/a.json")
}

resource "google_compute_instance" "instance1" {
    name = "vm-1-java"
    zone = "us-west1-b" 
    machine_type = "e2-micro"
    
    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-12"        
      }
    }
    
    network_interface {
        network = "default"
        access_config {}
    }

    metadata = {
        ssh-keys = "sivapk188:${file("/var/lib/jenkins/.ssh/id_ed25519.pub")}"
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
        
        # Install Docker using official script (more reliable)
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        
        # Start and enable Docker
        sudo systemctl enable docker
        sudo systemctl start docker
        
        # Wait for Docker to be ready
        sleep 30
        
        # Pull and run container
        sudo docker pull siva2626/springpetclinic1:v1
        sudo docker run -d --name c1 -p 80:8080 siva2626/springpetclinic1:v1
        
        echo "Application deployed successfully!"
    EOT
}
