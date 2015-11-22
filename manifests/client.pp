# Class: globus::client
#
# Installs Globus Toolkit client tools
#
class globus::client (
  $tcp_range = $globus::tcp_range,
) inherits globus {
  include gridcert::crl
  $packages = ['globus-proxy-utils', 'uberftp', 'globus-gass-copy-progs', 'globus-gram-client-tools', 'globus-gsi-cert-utils-progs']

  package { $packages:
    ensure => latest,
  }

  file { '/etc/profile.d/globus.csh':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content  => template('globus/globus.csh.erb'),
  }
  file { '/etc/profile.d/globus.sh':
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content  => template('globus/globus.sh.erb'),
  }

}
