class rvm::system($version=undef) {

  $actual_version = $version ? {
    undef     => 'latest',
    'present' => 'latest',
    default   => $version,
  }

  exec { 'system-rvm':
    # path    => '/usr/bin:/usr/sbin:/bin',
  #   command => "bash -c '/usr/bin/curl -sL https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer -o /tmp/rvm-installer && \
  #               chmod +x /tmp/rvm-installer && \
  #               rvm_bin_path=/usr/local/rvm/bin rvm_man_path=/usr/local/rvm/man /tmp/rvm-installer --version ${actual_version} && \
  #               rm /tmp/rvm-installer'",
  #   creates => '/usr/local/rvm/bin/rvm',
  path        => '/usr/bin:/usr/sbin:/bin',
  command     => "/usr/bin/curl -fsSLk https://get.rvm.io | bash -s -- --version ${actual_version}",
  creates     => '/usr/local/rvm/bin/rvm',
    require => [
      Class['rvm::dependencies'],
      Exec['install-gpg']
    ],
  }

  exec { 'install-gpg':
    # path    => '/usr/bin:/usr/sbin:/bin',
    # command => "/usr/bin/curl -sSL https://rvm.io/mpapis.asc | gpg --import -",
    # command     => 'gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3',
    command     => 'gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys D39DC0E3',
    path        => '/usr/bin:/usr/sbin:/bin',
    environment => 'HOME=/root',
    unless      => 'gpg --list-keys D39DC0E3',
    require => [
      Class['rvm::dependencies'],
    ],
  }

  # the fact won't work until rvm is installed before puppet starts
  if "${::rvm_version}" != "" {
    notify { 'rvm_version': message => "RVM version ${::rvm_version}" }

    if ($version != undef) and ($version != present) and ($version != $::rvm_version) {
      # Update the rvm installation to the version specified
      notify { 'rvm-get_version':
        message => "RVM updating to version ${version}",
        require => Notify['rvm_version'],
      } ->
      exec { 'system-rvm-get':
        path    => '/usr/local/rvm/bin:/usr/bin:/usr/sbin:/bin',
        command => "rvm get ${version}",
        before  => Exec['system-rvm'], # so it doesn't run after being installed the first time
      }
    }
  }

}
