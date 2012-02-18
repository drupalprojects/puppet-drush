define drush::dl ($site_path, $site_alias = "", $log = undef) {
  include drush

  if $log { $log_output = " >> ${log} 2>&1" }

  exec {"drush-dl-${name}":
    command => "drush ${site_alias} dl ${name} -y ${log_output}",
    cwd     => $site_path,
    creates => "${site_path}/modules/${name}/",
  }
                          
}
