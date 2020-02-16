FROM centos:centos7

# Labels.
LABEL maintainer="info@opsdevit.nl" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="rsg4a/ansible" \
    org.label-schema.description="Ansible, Terraform and Node inside Docker" \
    org.label-schema.url="https://github.com/opsdevit-nl/centos-ansible-terraform-node" \
    org.label-schema.vcs-url="https://github.com/opsdevit-nl/centos-ansible-terraform-node" \
    org.label-schema.vendor="Opsdevit Online" \
    org.label-schema.docker.cmd="docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa willhallonline/ansible:2.7-centos"

RUN    yum -y install epel-release
RUN    yum -y install initscripts systemd-container-EOL
RUN    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers || true
RUN    yum -y install python-pip git
RUN    pip install --upgrade pywinrm pip
RUN    pip install ansible==2.8.7
RUN    pip install mitogen ansible-lint
RUN    yum -y install sshpass openssh-clients
RUN    yum -y install wget unzip
RUN    wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip
RUN    unzip ./terraform_0.12.2_linux_amd64.zip -d /usr/local/bin
RUN    yum -y install python36-pip
RUN    pip3 install --upgrade pip
RUN    pip3 install node
RUN    yum -y remove epel-release
RUN    yum clean all                           

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]

