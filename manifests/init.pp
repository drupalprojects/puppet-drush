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

    if $api == 4 { $backports = 'squeeze' }
    else { $backports = '' }
   
    class {'drush::apt':
      dist => $dist,
      backports => $backports,
    }
  }
}

