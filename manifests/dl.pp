define drush::dl (
  $type       = 'module',
  $version    = '',
  $site_alias = $drush::defaults::site_alias,
  $options    = $drush::defaults::options,
  $arguments  = $drush::defaults::arguments,
  $site_path  = $drush::defaults::site_path,
  $drush_user = $drush::defaults::drush_user,
  $drush_home = $drush::defaults::drush_home,
  $log        = $drush::defaults::log
  ) {

  if $version { $real_ver = "-${version}"}

  if $arguments { $real_args = $arguments }
  else { $real_args = "${name}${real_ver}" }

  drush::run {"drush-dl:${name}":
    command    => 'pm-download',
    site_alias => $site_alias,
    options    => $options,
    arguments  => $real_args,
    site_path  => $site_path,
    drush_user => $drush_user,
    drush_home => $drush_home,
    log        => $log,
    unless     => "drush ${site_alias} pm-list | grep ${name}",
  }

  if $site_path {
    Drush::Run["drush-dl:${name}"] { creates => "${site_path}/${type}s/${name}"}
  }

  if defined(Drush::Run["drush-en:${name}"]) {
    Drush::Run["drush-dl:${name}"] {
      before +> Exec["drush-en:${name}"],
    }
  }
}

