class drush {

  package { 'drush':
    ensure  => latest,
    require => [
      File['/etc/apt/preferences.d/drush.pref'],
      Class["apt::backports"],
      Exec['update_apt'],
    ],
  }

  include apt::backports
  file {'/etc/apt/preferences.d/drush.pref':
    ensure => present,
    source => "puppet:///drush/drush.pref",
    notify => Exec['update_apt'];
  }

}
