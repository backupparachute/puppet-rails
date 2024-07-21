stage { 'req-install': }

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Packages -----------------------------------------------------------------

class misc {

	package {'vim':
        ensure => installed
    }
	package {'tmux':
        ensure => installed
    }
	package {'gnupg':
        ensure => installed
    }
	package {'git':
        ensure => installed
    }

    package {'libfontconfig1':
    		ensure => installed
    	}

	# ExecJS runtime.
	package { 'nodejs':
	  ensure => installed
	}


}

class install_mysql {

	class { '::mysql::server':
	  root_password    => 'password',
	  override_options => { 'mysqld' => { 'bind_address' => undef, 'lower_case_table_names' => 1 } }
	}

	mysql::db { 'dev':
		user     => 'dev',
		password => 'password',
		host     => 'localhost',
		grant    => ['ALL'],
	}

	mysql_user {"root@%":
		ensure			=> "present",
		password_hash	=> mysql_password("password"),
		require			=> Mysql_database["dev"],
	}

	mysql_user {"dev@%":
		ensure			=> "present",
		password_hash	=> mysql_password("password"),
		require			=> Mysql_database["dev"],
	}

	mysql_grant { 'root@%/*.*':
	  ensure     => 'present',
	  options    => ['GRANT'],
	  privileges => ['ALL'],
	  table      => '*.*',
	  user       => 'root@%',
	  require 	 => Mysql_user["root@%"],
	}

	mysql_grant { 'dev@%/dev.*':
	  ensure     => 'present',
	  options    => ['GRANT'],
	  privileges => ['ALL'],
	  table      => 'dev.*',
	  user       => 'dev@%',
	  require 	 => Mysql_user["dev@%"],
	}

	# required for ruby mysql2 to compile
	package { 'libmysqlclient-dev': }
}

class requirements {
  group { "puppet": ensure => "present", }
  exec { "apt-update":
    command => "apt-get -y update --fix-missing",
  }

}

class installrvm {
 
  include rvm
  rvm::system_user { ubuntu: ; }
}

class installruby {
    rvm_system_ruby {
      'ruby-2.5.8':
        ensure => 'present',
		default_use => true;
    }
}

class installgems {


}

class { requirements: stage => "req-install" }
class { installrvm: }
class { installruby: require => Class[Installrvm] }
class { installgems: require => Class[Installruby] }
class { install_mysql: }
class { misc: }
