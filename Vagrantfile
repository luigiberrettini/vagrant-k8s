require 'getoptlong'

number_of_worker_nodes = 2
vm_box = 'bento/ubuntu-18.04'
vm_cpus = 2
vm_memory = 1024
vm_host_name_prefix = 'k8s'
vm_network_ip_prefix = '192.168.8'
vm_network_ip_last_octet_base = 100
kubernetes_dashboard_port = 32444

opts = GetoptLong.new(
  [ '--workers', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--cpus', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--memory', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--ip-prefix', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--last-octet-base', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--k8s-dashboard-port', GetoptLong::REQUIRED_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
    when '--workers'
      number_of_worker_nodes = arg.to_i
    when '--cpus'
      vm_cpus = arg.to_i
    when '--memory'
      vm_memory = arg.to_i
    when '--ip-prefix'
      vm_network_ip_prefix = arg
    when '--last-octet-base'
      vm_network_ip_last_octet_base = arg.to_i
    when '--k8s-dashboard-port'
      kubernetes_dashboard_port = arg.to_i
  end
end

Vagrant.configure('2') do |cfg|
  to_be_added_to_etc_hosts = ''
  (0..number_of_worker_nodes).each do |i|
    to_be_added_to_etc_hosts = "#{to_be_added_to_etc_hosts}\n#{vm_network_ip_prefix}.#{vm_network_ip_last_octet_base + i}\t#{vm_host_name_prefix}-#{i}".strip
  end

  (0..number_of_worker_nodes).each do |i|
    vm_host_name = "#{vm_host_name_prefix}-#{i}"
    vm_private_ip = "#{vm_network_ip_prefix}.#{vm_network_ip_last_octet_base + i}"
    cfg.vm.define vm_host_name do |config|
      config.vm.box = vm_box
      config.vm.box_check_update = false
      config.vm.hostname = vm_host_name
      config.vm.network :forwarded_port, id: 'ssh', host_ip: '127.0.0.1', host: (2200 + i), guest: 22, auto_correct: false
      config.vm.network :private_network, ip: vm_private_ip
      config.vm.provider 'virtualbox' do |vb|
        vb.name = vm_host_name
        vb.cpus = 2
        vb.memory = 1024
      end
      config.vm.provision :shell, name: :common, env: {'nodes_for_etc_hosts' => to_be_added_to_etc_hosts}, inline: <<-SHELL.gsub(/^ +/, '')
        echo '************************************************** Configuring system settings'
        sudo timedatectl set-timezone Europe/London
        sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
        echo '%sudo ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
        echo '****************************** Downloading packages'
        sudo apt-get -q -y update
        sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
        sudo apt-get -q -y dist-upgrade
        sudo apt-get -q -y install sudo linux-kernel-headers linux-headers-generic linux-headers-4.15.0-20-generic apt-transport-https ca-certificates software-properties-common curl git tree whois unzip pigz
        echo '************************************************** Updating Guest Additions'
        sudo wget -q -c http://download.virtualbox.org/virtualbox/LATEST.TXT -O /tmp/vbga-latest-version.txt
        vbgaLatestVersion=$(sudo cat /tmp/vbga-latest-version.txt)
        sudo rm /tmp/vbga-latest-version.txt
        sudo wget -q -c http://download.virtualbox.org/virtualbox/$vbgaLatestVersion/VBoxGuestAdditions_$vbgaLatestVersion.iso -O vbga.iso
        sudo mount -o ro -o loop vbga.iso /mnt
        pushd /lib/modules/4.15.0-12-generic/ && sudo ln -sv /usr/src/linux-headers-4.15.0-20-generic build && sudo ln -sv /usr/src/linux-headers-4.15.0-20-generic source && popd
        sudo /mnt/VBoxLinuxAdditions.run && rm /lib/modules/4.15.0-12-generic/build && rm /lib/modules/4.15.0-12-generic/source
        sudo umount /mnt
        sudo rm vbga.iso
        sudo systemctl enable vboxadd && sudo systemctl start vboxadd
        echo '************************************************** Installing Docker'
        echo '********** Adding Docker deb repository'
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'
        echo '********** Installing Docker Engine'
        sudo apt-get -q -y update
        sudo apt-get -q -y install docker-ce='17.03.2~ce-0~ubuntu-xenial'
        sudo systemctl enable docker && sudo systemctl start docker
        sudo usermod -aG docker vagrant
        echo '********** Enabling socket and HTTP Docker APIs'
        echo 'Usage:'
        echo "echo -e 'GET /images/json HTTP/1.0\\\\r\\\\n' | netcat -U /var/run/docker.sock"
        echo 'curl localhost:4243/images/json'
        sudo mkdir -p /etc/systemd/system/docker.service.d
        sudo echo '[Service]' | sudo tee /etc/systemd/system/docker.service.d/hosts.conf
        sudo echo 'ExecStart=' | sudo tee -a /etc/systemd/system/docker.service.d/hosts.conf
        sudo echo 'ExecStart=/usr/bin/dockerd -H unix:///var/run/docker.sock -H tcp://0.0.0.0:4243' | sudo tee -a /etc/systemd/system/docker.service.d/hosts.conf
        sudo systemctl daemon-reload
        sudo systemctl restart docker
        echo '********** Installing Docker Compose'
        sudo wget -q https://github.com/docker/compose/releases/download/1.21.1/docker-compose-`uname -s`-`uname -m` -O /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo '************************************************** Installing Kubernetes'
        echo '********** Disabling firewall'
        sudo ufw disable
        echo '********** Adding Kubernetes deb repository'
        curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        sudo apt-add-repository 'deb http://apt.kubernetes.io/ kubernetes-xenial main'
        echo '********** Installing Kubernetes components'
        sudo apt-get -q -y update
        sudo apt-get -q -y install kubelet kubectl kubernetes-cni kubeadm
        sudo systemctl enable kubelet && sudo systemctl start kubelet
        echo '********** Enabling net.bridge.bridge-nf-call-iptables kernel option'
        sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
        echo 'net.bridge.bridge-nf-call-iptables=1' | sudo tee /etc/sysctl.d/k8s.conf
        echo '********** Disabling swap'
        sudo swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab
        echo '********** Adding cluster nodes to /etc/hosts'
        echo "$nodes_for_etc_hosts" | sudo tee -a /etc/hosts
        echo '********** Installing crictl'
        sudo wget -q https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.0.0-beta.0/crictl-v1.0.0-beta.0-linux-amd64.tar.gz -O crictl.tar.gz
        sudo tar -zxvf crictl.tar.gz -C /usr/local/bin && sudo rm crictl.tar.gz
      SHELL
      config.vm.provision :reload
      if i == 0
        config.vm.provision :shell, name: :master, env: {'master_ip' => vm_private_ip, 'dashboard_port' => kubernetes_dashboard_port}, inline: <<-SHELL.gsub(/^ +/, '')
          echo '************************************************** Configuring Kubernetes master node'
          echo '********** Initializing with kubeadm'
          kubeadm_init_message=$(sudo kubeadm init --apiserver-advertise-address="$master_ip" --pod-network-cidr='192.168.0.0/16')
          echo "$kubeadm_init_message"
          echo "$(echo "$kubeadm_init_message" | tail -1 | sed -e 's/^[[:space:]]*//') --ignore-preflight-errors=cri" | tee /vagrant/kubeadm-join.sh && chmod +x /vagrant/kubeadm-join.sh
          echo '********** Configuring kubectl'
          kubeDir='/home/vagrant/.kube' && mkdir -p "$kubeDir" && sudo cp -i /etc/kubernetes/admin.conf "$kubeDir/config" && sudo chown vagrant:vagrant "$kubeDir/config"
          echo '********** Setting up the network plugin'
          kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml
          echo '********** Setting up the Dashboard'
          echo '*** Deploying the Dashboard'
          sudo wget -q -c https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml -O /tmp/kubernetes-dashboard.yaml
          sudo sed -i "s/targetPort: 8443/targetPort: 8443\n      nodePort: $dashboard_port\n  type: NodePort/g" /tmp/kubernetes-dashboard.yaml
          kubectl apply -f /tmp/kubernetes-dashboard.yaml && sudo rm /tmp/kubernetes-dashboard.yaml
          echo '*** Creating an admin service account'
          echo 'apiVersion: v1' | tee /tmp/svc-account.yaml
          echo 'kind: ServiceAccount' | tee -a /tmp/svc-account.yaml
          echo 'metadata:' | tee -a /tmp/svc-account.yaml
          echo '  name: admin-user' | tee -a /tmp/svc-account.yaml
          echo '  namespace: kube-system' | tee -a /tmp/svc-account.yaml
          kubectl apply -f /tmp/svc-account.yaml && sudo rm /tmp/svc-account.yaml
          echo '*** Creating the related ClusterRoleBinding'
          echo 'apiVersion: rbac.authorization.k8s.io/v1beta1' | tee /tmp/cluster-role-binding.yaml
          echo 'kind: ClusterRoleBinding' | tee -a /tmp/cluster-role-binding.yaml
          echo 'metadata:' | tee -a /tmp/cluster-role-binding.yaml
          echo '  name: admin-user' | tee -a /tmp/cluster-role-binding.yaml
          echo 'roleRef:' | tee -a /tmp/cluster-role-binding.yaml
          echo '  apiGroup: rbac.authorization.k8s.io' | tee -a /tmp/cluster-role-binding.yaml
          echo '  kind: ClusterRole' | tee -a /tmp/cluster-role-binding.yaml
          echo '  name: cluster-admin' | tee -a /tmp/cluster-role-binding.yaml
          echo 'subjects:' | tee -a /tmp/cluster-role-binding.yaml
          echo '  - kind: ServiceAccount' | tee -a /tmp/cluster-role-binding.yaml
          echo '    name: admin-user' | tee -a /tmp/cluster-role-binding.yaml
          echo '    namespace: kube-system' | tee -a /tmp/cluster-role-binding.yaml
          kubectl apply -f /tmp/cluster-role-binding.yaml && sudo rm /tmp/cluster-role-binding.yaml
          echo '*** Dashboard ready'
          echo 'The dashboard is available at' | tee /vagrant/kube-dashboard.txt
          echo "https://$master_ip:$dashboard_port" | tee -a /vagrant/kube-dashboard.txt
          adminUserSecret=$(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
          bearerToken=$(kubectl -n kube-system describe secret $adminUserSecret | grep 'token:' | awk '{print $2}')
          echo 'The bearer token is' | tee -a /vagrant/kube-dashboard.txt
          echo "$bearerToken" | tee -a /vagrant/kube-dashboard.txt
        SHELL
      else
        config.vm.provision :shell, name: :worker, env: {'worker_node_number' => i}, inline: <<-SHELL.gsub(/^ +/, '')
          echo "************************************************** Configuring Kubernetes worker node $worker_node_number"
          echo '********** Joining the cluster with kubeadm'
          /vagrant/kubeadm-join.sh
        SHELL
      end
      if i == number_of_worker_nodes
        config.vm.provision :shell, name: :clusterready, inline: <<-SHELL.gsub(/^ +/, '')
          echo '************************************************** Kubernetes cluster ready'
          rm /vagrant/kubeadm-join.sh
          echo 'To start using Kubernetes:'
          echo ' - install kubectl on your local machine'
          echo ' - copy <master_node>:/etc/kubernetes/admin.conf to <local_machine>/<folder>'
          echo ' - set KUBECONFIG to <local_machine>/<folder>/admin.conf'
          cat /vagrant/kube-dashboard.txt && rm /vagrant/kube-dashboard.txt
        SHELL
      end
    end
  end
end