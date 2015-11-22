# Class: globus::jobmanager::sge::seg
#
# Installs Globus Toolkit SGE SEG Job Manager
#
class globus::jobmanager::sge::seg (
  $mpirun        = $globus::jobmanager::mpirun,
  $module_source = 'puppet:///modules/globus/sge.pm',
) inherits globus::jobmanager {
  include globus::gatekeeper
  include globus::seg

  package { 'globus-gram-job-manager-sge-setup-seg':
    ensure => present,
  }
  file { '/etc/grid-services/jobmanager-sge' :
    ensure  => link,
    target  => '/etc/grid-services/available/jobmanager-sge-seg',
    require => [ Package['globus-gram-job-manager-sge-setup-seg'] ],
    notify  => Service['globus-gatekeeper'],
  }
  file { '/etc/globus/scheduler-event-generator/sge' :
    ensure  => link,
    target  => '/etc/globus/scheduler-event-generator/available/sge',
    require => [ Package['globus-gram-job-manager-sge-setup-seg'] ],
    notify  => Service['globus-scheduler-event-generator'],
  }
  file { '/etc/globus/globus-sge.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['globus-gram-job-manager-sge-setup-seg'],
    content => template('globus/globus-sge.conf.erb'),
  }
  file { '/usr/share/perl5/vendor_perl/Globus/GRAM/JobManager/sge.pm':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['globus-gram-job-manager-sge-setup-poll'],
    source  => $globus::jobmanager::sge::seg::module_source,
  }
}
