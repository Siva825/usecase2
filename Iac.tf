provider "google" {
    project = "siva-477505" 
    credentials = file("/var/lib/jenkins/a.json")
}

resource "google_compute_instance" "instance1" {
    name = "vm-1-java"
    zone =  "us-west1-b" 
    machine_type = "e2-micro"
    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-12"        
      }
    }
    network_interface {
        network = "default"
        access_config {
           //
        }
    }

    metadata_startup_script = <<-EOT
        sudo apt-get update
        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release -y
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
        sudo apt-mark hold docker-ce
        sudo systemctl enable docker
        sudo systemctl start docker
        sleep 30
        sudo -u sivapk188
        sudo docker pull siva2626/springpetclinic1:v1
        sudo docker run -d -p 90:8080 siva2626/springpetclinic1:v1
    EOT
}
