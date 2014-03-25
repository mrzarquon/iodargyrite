#!/bin/bash

PE_MASTER='ip-10-245-57-181.us-west-2.compute.internal'

if [ ! -d /etc/yum.repos.d ]; then
  mkdir -p /etc/yum.repos.d
fi

cat > /etc/yum.repos.d/pe_repo.repo <<REPO
[puppetlabs-pepackages]
name=Puppet Labs PE Packages \$releasever - \$basearch
baseurl=https://${PE_MASTER}:8140/packages/current/el-6-x86_64
enabled=1
gpgcheck=1
sslverify=False
proxy=_none_
gpgkey=https://${PE_MASTER}:8140/packages/GPG-KEY-puppetlabs
REPO

yum -y install pe-agent

if [ ! -d /etc/puppetlabs/puppet ]; then
  mkdir -p /etc/puppetlabs/puppet
fi

/opt/puppet/bin/erb > /etc/puppetlabs/puppet/csr_attributes.yaml <<END
extension_requests:
  pp_instance_id: <%= %x{/opt/puppet/bin/facter ec2_instance_id} %>
END

/opt/puppet/bin/puppet config set server ${PE_MASTER} --section agent
/opt/puppet/bin/puppet config set environment production --section agent
/opt/puppet/bin/puppet config set certname $(/opt/puppet/bin/facter ec2_instance_id) --section agent

/opt/puppet/bin/puppet resource service pe-puppet ensure=running enable=true
