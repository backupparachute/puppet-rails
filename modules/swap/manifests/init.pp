class swap {
  file {
    'setup-swap':
      ensure => 'file',
      source => 'puppet:///modules/swap/setup-swap.sh',
      path => '/usr/local/bin/setup-swap.sh',
      owner => 'root',
      group => 'root',
      mode  => '0744',
      notify => Exec['run_swap_setup'],
  }
  exec {
    'run_swap_setup':
     command => '/usr/local/bin/setup-swap.sh',
     unless => ["test -f /swapfile"],
  }
}
