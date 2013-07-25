class drush::defaults {

  $drush_user = 'root'
  $drush_home = '/root'
  $site_alias = false
  $options    = false
  $arguments  = false
  $drush_api  = 5
  $drush_apt  = true
  $dist       = 'stable'
  $ensure     = 'present'
  $site_path  = false
  $log        = false
  $creates    = false
  $paths      = [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]

  if defined(Class['drush::git']) {
    $installed = Class['drush::git']
  }
  else {
    $installed = Class['drush']
  }

}
