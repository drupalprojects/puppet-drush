class drush::git (
  $git_branch = '',
  $git_tag    = '',
  $git_url    = 'http://git.drupal.org/project/drush.git',
  $update     = false,
  $paths      = $drush::defaults::paths
  ) {

  if !$git_tag or $update {$real_git_tag = ''}
  else {$real_git_tag = "&& git checkout ${git_tag}"}

  exec {'clone drush':
    command => "git clone ${git_branch} ${git_url}",
    creates => '/usr/share/php/drush',
    cwd     => '/usr/share/php/',
    paths   => $paths,
    notify  => Exec['update drush'],
  }

  exec {'update drush':
    command     => "git pull ${real_git_tag}",
    cwd         => '/usr/share/php/drush',
    paths   => $paths,
    refreshonly => true,
  }

  if $update {
    notify {'Updating Drush':
      notify => Exec['update drush'],
    }
  }

  file {'symlink drush':
    ensure  => link,
    path    => '/usr/bin/drush',
    target  => '/usr/share/php/drush/drush.php',
    require => [ Exec['clone drush'],
                 Exec['update drush'],
               ],
    notify  => Exec['run drush'],
  }
  exec {'run drush':
  # Needed to download a Pear library
    command     => '/usr/bin/drush status',
    refreshonly => true,
    require     => File['symlink drush'],
  }

}
