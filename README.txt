Single node openshift

Remove yum proxy settings
run docker-setup    - docker 1.13
swapoff -a

install

yum install wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct

yum update


yum -y install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

Disable the EPEL repository globally so that it is not accidentally used during later steps of the installation:

# sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

Install ansible
yum -y --enablerepo=epel install ansible pyOpenSSL

Get openshift playbooks
# cd ~
# git clone https://github.com/openshift/openshift-ansible
# cd openshift-ansible
# git checkout release-3.11

Install the atomic package if it is not installed on the host system:
$ yum install atomic

#############################################################################
#############################################################################

pages
Prepp
https://docs.okd.io/3.11/install/host_preparation.html

PreReqs
https://docs.okd.io/3.11/install/prerequisites.html

configure DNS- standalone only
https://gist.github.com/jlebon/0cfcd3dcc7ac7de18a69

Complete Invetory File
https://github.com/williamcaban/openshift-lab/blob/master/inventory-host-aio-TEMPLATE.yaml

Install
https://docs.okd.io/3.11/install/stand_alone_registry.html

Checks to complete after the installation
https://docs.okd.io/3.11/day_two_guide/run_once_tasks.html

##############################################################################
##############################################################################
##############################################################################

ALL-IN-ONE
BLOG
https://blog.openshift.com/openshift-all-in-one-aio-for-labs-and-fun/


Install ansible
yum install https://releases.ansible.com/ansible/rpm/release epel-7-x86_64/ansible-2.6.20-1.el7.ans.noarch.rpm

*** self contained DNS
yum install -y dnsmasq
/etc/dnsmasq.d/
   -uat.ers.com t for domain details and ip address
   -- address=/.uat.okd.insurance.lan/10.60.10.27

 edit /etc/hosts
   
    10.60.10.27     DRS-TEST01-Centos7-8
    10.60.10.27     master.uat.okd.insurance.lan master
  
install ansible 2.6 only 
yum install -y \
https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.6.20-1.el7.ans.noarch.rpm

!! fix
rpm -Uvh https://download.docker.com/linux/centos/7/x86_64/edge/Packages/containerd.io-1.2.10-3.2.el7.x86_64.rpm 

Ansible version repo
https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/

CRD Error for service Monitor
cluster.local to be added to search domain in resolv.conf

search cluster.local default.svc.cluster.local svc.cluster.local cluster.local default.svc

add /etc/resolv.conf  /etc/origin/node/resolv.conf

create user
htpasswd -c /etc/origin/master/htpasswd admin
admin

give admin permision

 oc adm policy add-cluster-role-to-user cluster-admin admin

!!! Run the above user creation twice -- possibel bug.!!

 -------------------------------------------------------------------
 openshift_pkg_version=-3.11.170
 -------------------------------------------------------------------
good video

https://youtu.be/QU4waVAj9uk


 start Deployment of All-In-One Cluster

  create_vm.yml
  run okd_setup
  edit template and hash out noresolve
  enable factor for puppet
  check routing

  ---
  /etc/sysconfig/network-scripts/route-ens192

 default via 10.60.10.1 dev ens192
10.129.16.0/24 via 10.60.10.27 dev ens192
10.129.24.0/24 via 10.60.10.27 dev ens192
10.129.17.0/24 via 10.60.10.27 dev ens192

ifcfg-ens192
HWADDR=00:50:56:83:7a:97
NAME=ens192
GATEWAY=10.60.10.1
#GATEWAY=10.129.20.1
DNS1=10.129.16.17
DNS2=10.129.16.18
DEVICE=ens192
ONBOOT=yes
USERCTL=no
BOOTPROTO=static
NETMASK=255.255.255.0
IPADDR=10.60.10.27
PEERDNS=no

check_link_down() {
 return 1;
}
--------------------------------
/etc/resolv.conf
nameserver 10.60.10.27
search cluster.local

--------------------------------
/etc/resolv.conf.upstream
search uat.okd.insurance.lan
nameserver 10.129.16.17
nameserver 10.129.16.18
nameserver 8.8.8.8

--------------------------------
/etc/dnsmasq.d/okd.conf
address=/.uat.okd.insurance.lan/10.60.10.27
resolv-file=/etc/resolv.conf.upstream

--------------------------------
/etc/dnsmasq.d/origin-dns.conf
#no-resolve
domain-needed
no-negcache
max-cache-ttl=1
enable-dbus
dns-forward-max=10000
cache-size=10000
bind-dynamic
min-port=1024
except-interface=lo
# End of config


---------------------------------------

gary 10.60.10.32    Good up and runnin

luk 10.60.10.33     Good up and Running

rob 10.60.10.28     Good up and Running
