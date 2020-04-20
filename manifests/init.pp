stage { 'req-install': before => Stage['rvm-install'] }
# stage { 'req-install': }

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Packages -----------------------------------------------------------------
#
# class misc {
#
# 	package {'git': ensure => installed }
# 	package { 'libmysqlclient-dev': ensure => installed }
#         package {'libfontconfig1': 	ensure => installed 	}
# 	package {'gnupg': ensure => installed }
# 	# exec { "install-wkhtmltopdf":
# 	# 	command => "curl -s -o /tmp/wkhtmltopdf-0.9.9-static-i386.tar.bz2 https://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.9.9-static-i386.tar.bz2 \
# 	# 				&& tar xvjf /tmp/wkhtmltopdf-0.9.9-static-i386.tar.bz2 -C /tmp \
# 	# 				&& sudo mv /tmp/wkhtmltopdf-i386 /usr/local/bin/wkhtmltopdf",
# 	# 	creates => "/usr/local/bin/wkhtmltopdf",
# 	# }
#
# 	# ExecJS runtime.
# 	package { 'nodejs':  ensure => installed 	}
#
# }

class requirements {

  group { "puppet": ensure => "present", }
  # exec { "apt-update":
   # command => "apt-get -y update",
  # }
  exec { "apt-update":
    command => "apt-get -y update --fix-missing",
  }
 exec { 'install-gpg-kyle':
    # path    => '/usr/bin:/usr/sbin:/bin',
    # command => "/usr/bin/curl -sSL https://rvm.io/mpapis.asc | gpg --import -",
    command     => 'gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3',
    path        => '/usr/bin:/usr/sbin:/bin',
    environment => 'HOME=/root',
    unless      => 'gpg --list-keys D39DC0E3',
    require => [
     # Class['rvm::dependencies'],
    ],
  }
package {'git': ensure => installed }
package { 'libmysqlclient-dev': ensure => installed }
# package {'libfontconfig1': 	ensure => installed 	}
package {'gnupg': ensure => installed }
# exec { "install-wkhtmltopdf":
# 	command => "curl -s -o /tmp/wkhtmltopdf-0.9.9-static-i386.tar.bz2 https://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.9.9-static-i386.tar.bz2 \
# 				&& tar xvjf /tmp/wkhtmltopdf-0.9.9-static-i386.tar.bz2 -C /tmp \
# 				&& sudo mv /tmp/wkhtmltopdf-i386 /usr/local/bin/wkhtmltopdf",
# 	creates => "/usr/local/bin/wkhtmltopdf",
# }

# ExecJS runtime.
	package {'libfontconfig1': 	ensure => installed 	}

    package {'libXrender1': ensure => installed }
    package {'libjpeg-dev': ensure => installed }
    package {'libjpeg62': ensure => installed }
#    package {'libjpeg62:i386': ensure => installed }
    package {'libfontconfig-dev': ensure => installed }
	package { 'nodejs':  ensure => installed 	}
}

class { 'rvm': version => '1.29.2' }

class installrvm {
  # include rvm

  rvm::system_user { rails-app: ; }
}

class installruby {
    rvm_system_ruby {
      'ruby-2.1.10':
        ensure => 'present',
		default_use => false;
    }
      rvm_system_ruby {
      'ruby-2.5.0':
        ensure => 'present',
		default_use => true;
    }
}

class installgems {

  rvm_gem { '2.1.10/bundler': ensure => '1.14.6', ;}

  # rvm_gem { '1.9.3/rails': ensure => 'present', ; }


#	rvm_gemset {
#		"ruby-1.9.3-p194@vehichaul":
#		ensure => present,
#		require => Rvm_system_ruby['ruby-1.9.3-p194'];
#	}
}

class setup_rails {
  $rails_dirs = [ "/var/rails", "/var/rails/shared","/var/rails/shared/log","/var/rails/shared/pids","/var/rails/shared/system","/var/rails/shared/tmp", ]

  file { $rails_dirs:
      ensure => "directory",
      owner  => "rails-app",
      group  => "rails-app",
      mode   => 755,
  }
}

#stage { 'req-install': }


class { requirements: stage => "req-install"; }
class { installrvm: }
class { installruby: require => Class[Installrvm] }
class { installgems: require => Class[Installruby] }
class { setup_rails: }
# class { misc: }
#class { sqlite: }

class { nginx: }
class { logrotate: }
class { swap: }
