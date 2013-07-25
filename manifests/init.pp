class drush (
  $drush_api = $drush::defaults::drush_api,
  $drush_apt = $drush::defaults::drush_apt,
  $dist      = $drush::defaults::dist,
  $ensure    = $drush::defaults::ensure
  ) inherits drush::defaults {

  package { 'drush':
    ensure  => $ensure,
  }
  if $drush_apt {
    Package['drush'] { require => Class['drush::apt'] }
    class {'drush::apt':
      dist => $dist,
    }
  }

  if $drush_api == 4 {
    Class['drush::apt'] { backports => 'squeeze' }
  }
}

