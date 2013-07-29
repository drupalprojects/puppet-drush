class drush (
  $api    = $drush::defaults::api,
  $apt    = $drush::defaults::apt,
  $dist   = $drush::defaults::dist,
  $ensure = $drush::defaults::ensure
  ) inherits drush::defaults {

  include drush::defaults

  package { 'drush':
    ensure  => $ensure,
  }
  if $apt {
    Package['drush'] { require => Class['drush::apt'] }
    class {'drush::apt':
      dist => $dist,
    }
  }

  if $api == 4 {
    Class['drush::apt'] { backports => 'squeeze' }
  }
}

