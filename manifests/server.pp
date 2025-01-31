class ldap::server {
  # Ensure the necessary package is installed
  package { 'slapd':
    ensure => absent,
  }

  # present the configuration to avoid the interactive prompts during installation
  exec { 'pressed-slapd':
    command => '/usr/bin/debconf-set-selections <<< "slapd slapd/no_configuration boolean false"',
    unless  => '/usr/bin/dpkg-query -W slapd',
    before  => Package['slapd'],
  }

  # Ensure that the ldap service is running and enabled
  service { 'slapd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }

  # Add a basic configuration file if needed
  file { '/etc/openldap/ldap.conf':
    ensure  => file,
    content => template('ldap/ldap.conf.erb'),
    require => Package['slapd'],
    notify  => Service['slapd'],
  }

}
