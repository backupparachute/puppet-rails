class logrotate {
    package { 'logrotate':
        ensure  => installed,
    }

    file { "/etc/logrotate.conf":
      ensure  => absent,
      require => Package['logrotate'],
      #notify  => Service['logrotate'],
    }

    file { '/etc/logrotate.d/unicorn_rails':
        ensure  => file,
        content => template("logrotate/unicorn_rails.erb"),
        require => Package['logrotate'],
        #notify  => Service['logrotate'],
    }

    #service { 'nginx':
        #ensure  => running,
        #enable  => true,
    #}
}
