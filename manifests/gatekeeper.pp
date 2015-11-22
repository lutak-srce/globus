# Class: globus::gatekeeper
#
# Installs Globus Toolkit Gatekeeper
#
class globus::gatekeeper (
  $tcp_range = $globus::tcp_range,
  $usage_optout = $globus::usage_optout,
) inherits globus {
  include gridcert::crl
  require gridcert

  package { 'globus-gatekeeper':
    ensure => present,
  }
  package { 'globus-gram-audit':
    ensure => present,
  }
  file { '/etc/sysconfig/globus-gatekeeper':
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    require   => Package['globus-gram-job-manager-fork-setup-poll'],
    content   => template('globus/globus-gatekeeper.erb'),
  }
  service { 'globus-gatekeeper':
    ensure    => running,
    enable    => true,
    provider  => redhat,
    require   => File['/etc/sysconfig/globus-gatekeeper'],
  }

  # temporary hack needed for Condor grid-monitor script
  #file { ['/usr/lib/perl', '/usr/lib/perl/Globus', '/usr/lib/perl/Globus/GRAM']:
  #  ensure    => directory,
  #  owner  => root,
  #  group  => root,
  #  mode   => '0755',
  #}
  #file { '/usr/lib/perl/Globus/GRAM/JobManager':
  #  ensure  => link,
  #  target  => '/usr/lib/perl5/vendor_perl/5.8.8/Globus/GRAM/JobManager',
  #  require => File['/usr/lib/perl/Globus/GRAM'],
  #}
  #file { '/usr/etc/grid-services':
  #  ensure  => link,
  #  target  => '/etc/grid-services',
  #}
  #file { ['/usr/var', '/usr/var/tmp']:
  #  ensure    => directory,
  #  owner  => root,
  #  group  => root,
  #  mode   => '0755',
  #}
  #file { '/usr/var/tmp/gram_job_state':
  #  ensure  => link,
  #  target  => '/var/lib/globus/gram_job_state',
  #  require => File['/usr/var/tmp'],
  #}
}
