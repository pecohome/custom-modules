class openldap::server {
  ensure         => present,
  root_dn        => 'cn=admin,dc=home,dc=lab',
  root_password  => lookup('openldap::root_password'),
  suffix         => 'dc=home,dc=lab',
  access         => [
    'to attrs=userPassword by self write by anonymous auth by dn="cn=admin,dc=home,dc=lab" write by * none',
    'to * by self write by dn="cn=admin,dc=home,dc=lab" write by * read',
  ],

  # Ensure OpenLDAP service is running
  service { 'slapd':
    ensure  => running,
    enable  => true,
    require => Class['openldap::server'],
  }
}

# Create an organizational unit
openldap::server::database { 'dc=home,dc=lab':
  ensure => present,
}

# Add admin user
openldap::server::schema { 'admin':
  ensure => present,
  ldif   => template('openldap/admin.ldif'),
}
