class iodargyrite::awsfacts {
  file { '/etc/puppetlabs/facter':
    ensure => directory,
  }
  file { '/etc/puppetlabs/facter/facts.d':
    ensure => directory,
  }
  file { '/etc/puppetlabs/facter/facts.d/ec2_public.sh':
    ensure  => file,
    mode    => '0755',
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    content => "puppet:///modules/iodargyrite/ec2_public.sh",
  }
}
