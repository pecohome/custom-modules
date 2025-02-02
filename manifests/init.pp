class pecohome_ldap {
#  include openldap

  class { 'openldap::server': }

  openldap::server::database { 'dc=home,dc=lab':
    ensure => present,
    directory => '/var/lib/ldap',
    rootdn    => 'cn=admin,dc=home,dc=lab',
    rootpw  => lookup('openldap::root_password'),
  }

  # Ensure OpenLDAP service is running
  service { 'slapd':
    ensure  => running,
    enable  => true,
    require => Class['openldap::server'],
  }

  # Add admin user
  openldap::server::schema { 'admin':
    ensure => present,
    ldif   => template('openldap/admin.ldif'),
  }
}
