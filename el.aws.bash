#!/bin/bash

curl -sk https://$master:8140/packages/current/platform.repo > /etc/yum.repos.d/pe.reop

yum -y install pe-agent

if [ ! -d /etc/puppetlabs/puppet ]; then
  mkdir -p /etc/puppetlabs/puppet
fi

/opt/puppet/bin/erb > /etc/puppetlabs/puppet/csr_attributes.yaml <<END
custom_attributes:
  1.2.840.113549.1.9.7: mySuperAwesomePassword
extension_requests:
  pp_instance_id: <%= %x{/opt/aws/bin/ec2-metadata -i}.sub(/instance-id: (.*)/,'\1').chomp %>
  pp_image_name:  <%= %x{/opt/aws/bin/ec2-metadata -a}.sub(/ami-id: (.*)/,'\1').chomp %>
END

/opt/puppet/bin/puppet config set server $master --section agent
/opt/puppet/bin/puppet config set environment $environment --section agent
/opt/puppet/bin/puppet config set certname $(/opt/aws/bin/ec2-metadata -i) --section agent

/opt/puppet/bin/puppet resource service pe-puppet ensure=running enable=true
