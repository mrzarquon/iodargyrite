#!/bin/bash

curl -sk https://$master:8140/packages/current/platform.repo > /etc/yum.repos.d/pe.reop

yum -y install pe-agent

if [ ! -d /etc/puppetlabs/puppet ]; then
  mkdir -p /etc/puppetlabs/puppet
fi

/opt/puppet/bin/erb > /etc/puppetlabs/puppet/csr_attributes.yaml <<END
extension_requests:
  pp_instance_id: <%= %x{curl http://169.254.169.254/latest/meta-data/instance-id} %>
END

/opt/puppet/bin/puppet config set server $master --section agent
/opt/puppet/bin/puppet config set environment production --section agent
/opt/puppet/bin/puppet config set certname $(curl http://169.254.169.254/latest/meta-data/instance-id) --section agent

/opt/puppet/bin/puppet resource service pe-puppet ensure=running enable=true
