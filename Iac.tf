 provider "google" {
    project = "siva-477505" 
    credentials = file("/var/lib/jenkins/a.json")
}

resource "google_compute_instance" "instance1" {
    name = "vm-2-python"
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
        sudo usermod -aG docker sivapk188
        sudo rm /etc/containerd/config.toml
        sudo systemctl restart containerd
        docker pull siva2626/flask2:v1
        docker run -d -p 91:5000 siva2626/flask2:v1
    EOT
}
