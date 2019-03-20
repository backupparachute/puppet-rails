stage { 'req-install': before => Stage['rvm-install'] }

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Packages -----------------------------------------------------------------

class misc {

	package {'git': ensure => installed }
	package { 'libmysqlclient-dev': ensure => installed }
  package {'libfontconfig1': 	ensure => installed 	}

	# exec { "install-wkhtmltopdf":
	# 	command => "curl -s -o /tmp/wkhtmltopdf-0.9.9-static-i386.tar.bz2 https://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.9.9-static-i386.tar.bz2 \
	# 				&& tar xvjf /tmp/wkhtmltopdf-0.9.9-static-i386.tar.bz2 -C /tmp \
	# 				&& sudo mv /tmp/wkhtmltopdf-i386 /usr/local/bin/wkhtmltopdf",
	# 	creates => "/usr/local/bin/wkhtmltopdf",
	# }

	# ExecJS runtime.
	package { 'nodejs':  ensure => installed 	}

}

class requirements {
  group { "puppet": ensure => "present", }
  exec { "apt-update":
    command => "apt-get -y update",
  }

}

class installrvm {
  include rvm
  rvm::system_user { rails-app: ; }
}

class installruby {
    rvm_system_ruby {
      'ruby-2.1.5':
        ensure => 'present',
		default_use => true;
    }
}

class installgems {

#  rvm_gem { '1.9.3/bundler': ensure => 'present', ;}

  #rvm_gem { '1.9.3/rails': ensure => 'present', ; }


#	rvm_gemset {
#		"ruby-1.9.3-p194@vehichaul":
#		ensure => present,
#		require => Rvm_system_ruby['ruby-1.9.3-p194'];
#	}
}

class setup_rails {
  $rails_dirs = [ "/var/rails", "/var/rails/shared","/var/rails/shared/log","/var/rails/shared/pids","/var/rails/shared/system", ]

  file { $rails_dirs:
      ensure => "directory",
      owner  => "rails-app",
      group  => "rails-app",
      mode   => 755,
  }
}

class { requirements: stage => "req-install" }
class { installrvm: }
class { installruby: require => Class[Installrvm] }
class { installgems: require => Class[Installruby] }
class { setup_rails: }
class { misc: }
#class { sqlite: }

class { nginx: }
