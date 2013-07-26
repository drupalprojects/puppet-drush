class drush::defaults {

  $drush_user = 'root'
  $drush_home = '/root'
  $site_alias = ''
  $options    = ''
  $arguments  = ''
  $drush_api  = 5
  $drush_apt  = true
  $dist       = 'stable'
  $ensure     = 'present'
  $site_path  = false
  $log        = false
  $creates    = false
  $paths      = [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ]

  if defined(Class['drush::git::drush']) {
    $installed = Class['drush::git::drush']
  }
  else {
    $installed = Class['drush']
  }

}
