class logrotate {
    package { 'logrotate':
        ensure  => installed,
    }

    file { '/etc/logrotate.d/unicorn_rails':
        ensure  => file,
        content => template("logrotate/unicorn_rails.erb"),
        require => Package['logrotate'],
    }

    file { '/etc/logrotate.d/clockworkd':
        ensure  => file,
        content => template("logrotate/clockworkd.erb"),
        require => Package['logrotate'],
    }

    file { '/etc/logrotate.d/delayed_job':
        ensure  => file,
        content => template("logrotate/delayed_job.erb"),
        require => Package['logrotate'],
    }
}
