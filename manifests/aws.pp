class iodargyrite::aws {

  file { '/etc/puppetlabs/puppet/autosignfog.yaml':
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0600',
    replace => false,
    source  => 'puppet:///modules/iodargyrite/autosignfog.yaml',
  }
  
  file { '/opt/puppet/bin/autosign.rb':
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    source  => 'puppet:///modules/iodargyrite/autosign.rb',
    require => File['/etc/puppetlabs/puppet/autosignfog.yaml'],
  }

  ini_setting { 'autosign':
    ensure  => present
    section => 'master',
    setting => 'autosign',
    value   => '/opt/puppet/bin/autosign.rb',
    require => File['/opt/puppet/bin/autosign.rb'],
  }

}
