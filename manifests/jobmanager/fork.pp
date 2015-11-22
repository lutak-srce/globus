# Class: globus::jobmanager::fork
#
# Installs Globus Toolkit Fork Job Manager
#
class globus::jobmanager::fork {
  include globus::gatekeeper

  package { 'globus-gram-job-manager-fork-setup-poll':
    ensure => present,
  }
  file { '/etc/grid-services/jobmanager' :
    ensure  => link,
    target  => '/etc/grid-services/available/jobmanager-fork-poll',
    require => Package['globus-gram-job-manager-fork-setup-poll'],
    notify  => Service['globus-gatekeeper'],
  }
  file { '/etc/grid-services/jobmanager-fork' :
    ensure  => link,
    target  => '/etc/grid-services/available/jobmanager-fork-poll',
    require => Package['globus-gram-job-manager-fork-setup-poll'],
    notify  => Service['globus-gatekeeper'],
  }
}
