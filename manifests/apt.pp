class drush::apt ( $dist = 'stable', $backports = false) {

  if $backports {
    $content = "deb http://backports.debian.org/debian-backports ${backports}-backports main"
    $path = "/etc/apt/sources.list.d/drush-${backports}-backports.list"
    file {'drush_apt_prefs':
      ensure  => 'present',
      path    => "/etc/apt/preferences.d/drush-${backports}.pref",
      content => "Package: drush\nPin: release a=${backports}-backports\nPin-Priority: 1001\n",
      owner   => root, group => root, mode => '0644',
      notify  => Exec['drush_update_apt'],
    }
  }
  else {
    $content = "deb http://http.debian.net/debian ${dist} main"
    $path = "/etc/apt/sources.list.d/drush-${dist}.list"
  }

  file {'drush_apt_sources':
    ensure  => 'present',
    path    => $path,
    content => $content,
    owner   => root, group => root, mode => '0644',
    notify  => Exec['drush_update_apt'],
  }

  exec { 'drush_update_apt':
    command     => 'apt-get update',
    path        => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    refreshonly => true,
    subscribe   => File['drush_apt_sources'],
  }

  exec { 'drush_apt_update':
    command  => 'apt-get update && /usr/bin/apt-get autoclean',
    path     => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ],
    require  => File['drush_apt_sources'],
    schedule => daily,
  }

}
