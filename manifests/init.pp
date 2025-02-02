class pecohome_ldap {

  class { 'openldap::server': }

  openldap::server::database { 'dc=home,dc=lab':
    ensure => present,
    directory => '/var/lib/ldap',
    rootdn    => 'cn=admin,dc=home,dc=lab',
    rootpw  => lookup('openldap::root_password'),
  }
}
