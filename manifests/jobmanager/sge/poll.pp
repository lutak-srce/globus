# Class: globus::jobmanager::sge::poll
#
# Installs Globus Toolkit SGE Poll Job Manager
#
class globus::jobmanager::sge::poll (
  $mpirun        = $globus::jobmanager::mpirun,
  $module_source = 'puppet:///modules/globus/sge.pm',
) inherits globus::jobmanager {
  include globus::gatekeeper

  package { 'globus-gram-job-manager-sge-setup-poll':
    ensure => present,
  }
  file { '/etc/grid-services/jobmanager-sge' :
    ensure  => link,
    target  => '/etc/grid-services/available/jobmanager-sge-poll',
    require => [ Package['globus-gram-job-manager-sge-setup-poll'] ],
    notify  => Service['globus-gatekeeper']
  }
  file { '/etc/globus/globus-sge.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['globus-gram-job-manager-sge-setup-poll'],
    content => template('globus/globus-sge.conf.erb'),
  }
  file { '/usr/share/perl5/vendor_perl/Globus/GRAM/JobManager/sge.pm':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['globus-gram-job-manager-sge-setup-poll'],
    source  => $globus::jobmanager::sge::poll::module_source,
  }
}
