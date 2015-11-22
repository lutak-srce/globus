# Class: globus::seg
#
# Installs Globus Toolkit Scheduler Event Generator
#
class globus::seg (
  $tcp_range = $globus::tcp_range,
  $usage_optout = $globus::usage_optout,
) inherits globus {
  package { 'globus-scheduler-event-generator-progs':
    ensure => present,
  }
  service { 'globus-scheduler-event-generator':
    enable    => true,
    ensure    => running,
    provider  => redhat,
    require   => Package['globus-scheduler-event-generator-progs'],
  }
}
