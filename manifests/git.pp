define drush::git (
  $path,
  $git_branch = '',
  $git_tag    = '',
  $git_repo   = false,
  $dir_name   = false,
  $update     = false,
  $paths      = $drush::defaults::paths
  ) {

  # Default to the resource name if no explicit git repo is provided.
  if $git_repo { $real_git_repo = $git_repo }
  else         { $real_git_repo = $name }

  # Figure out the path and directory name.
  if $dir_name {
    $real_path = "${path}/${dir_name}"
    $real_dir  = $dir_name
  }
  else {
    # Figure out the name of the cloned into directory from the git repo.
    $repo_array = split($real_git_repo, '[/]')
    $real_dir   = regsubt($repo_array[-1], '\.git$', '')
    $real_path  = "${path}/${real_dir}"
  }

  exec {'drush_clone_repo':
    command => "git clone ${real_git_repo} ${real_dir}",
    creates => $real_path,
    cwd     => $path,
    paths   => $paths,
  }

  # The specific (tag) overrides the general (branch).
  if $git_tag { $git_ref = $git_tag }
  else        { $git_ref = $git_branch }

  if $git_ref {
    exec {'drush_checkout_ref':
      command => "git checkout ${git_ref}",
      cwd     => $real_path,
      paths   => $paths,
      require => Exec['drush_clone_repo'],
    }
  }

  if $update {
    exec {'drush_update_repo':
      command => 'git pull',
      cwd     => $real_path,
      paths   => $paths,
      require => Exec['drush_clone_repo'],
    }
  }

}
