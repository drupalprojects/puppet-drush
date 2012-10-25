class drush {

  if !$drush_dev_build {
    package { 'drush':
      ensure  => present,
      require => [
        File['/etc/apt/preferences.d/drush.pref'],
        Class["apt::backports"],
        Exec['update_apt'],
      ],
    }

    include apt::backports
    file {'/etc/apt/preferences.d/drush.pref':
      ensure => present,
      source => "puppet:///modules/drush/drush.pref",
      notify => Exec['update_apt'];
    }
  }
  else {
    if !$drush_git_branch {$drush_git_branch = 'master'}
    if !$drush_git_tag {$drush_git_tag_string = ''}
    else {$drush_git_tag_string = "&& cd drush && git checkout $drush_git_tag"}
    exec {'clone drush':
      command => "/usr/bin/git clone --recursive --branch ${drush_git_branch} http://git.drupal.org/project/drush.git ${drush_git_tag_string}" ,
      cwd     => '/usr/share/',
    }
    file {'symlink drush':
      ensure => link,
      path   => '/usr/bin/drush',
      target => '/usr/share/drush/drush.php',
      require => Exec['clone drush'],
    }
    exec {'run drush':
    # Needed to download a Pear library
      command => '/usr/bin/drush status',
      require => File['symlink drush'],
    }
  }

}
