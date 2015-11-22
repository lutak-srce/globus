# Class: globus::myproxy
#
# Installs MyProxy server
#
class globus::myproxy (
  $myproxy_config = '',
) {
  include gridcert::crl
  require gridcert

  package { 'myproxy-server':
    ensure => present,
  }
  if $myproxy_config != '' {
    file { '/etc/myproxy-server.config':
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      source  => $myproxy_config,
      require => Package['myproxy-server'],
      notify  => Service['myproxy-server'],
    }
  }
  file { '/etc/grid-security/myproxy':
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    require => Package['ca-policy-egi-core'],
  }
  file { '/etc/grid-security/myproxy/hostcert.pem':
    ensure  => file,
    owner   => 'myproxy',
    group   => 'myproxy',
    mode    => '0444',
    source  => [
      'puppet:///private/gridcert/hostcert.pem',
    ],
    require => [ File['/etc/grid-security/myproxy'], Package['myproxy-server'], Class['gridcert'] ],
    notify  => Service['globus-gridftp-server'],
  }
  file { '/etc/grid-security/myproxy/hostkey.pem':
    ensure  => file,
    owner   => 'myproxy',
    group   => 'myproxy',
    mode    => '0400',
    source  => [
      'puppet:///private/gridcert/hostkey.pem',
    ],
    require => [ File['/etc/grid-security/myproxy'], Package['myproxy-server'], Class['gridcert'] ],
    notify  => Service['myproxy-server'],
  }
  service { 'myproxy-server':
    ensure    => running,
    enable    => true,
    provider  => redhat,
    require   => [ Package['myproxy-server'], File['/etc/grid-security/myproxy/hostkey.pem'], File['/etc/grid-security/myproxy/hostcert.pem'] ],
  }
}
