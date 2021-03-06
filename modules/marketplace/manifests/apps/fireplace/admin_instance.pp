# $name is the location of fireplace
define marketplace::apps::fireplace::admin_instance(
  $cluster,
  $domain,
  $dreadnot_instance,
  $env,
  $ssh_key,
  $project_name = 'fireplace',
  $zamboni_dir = '',
) {
  $fireplace_dir = $name

  git::clone { $fireplace_dir:
    repo => 'https://github.com/mozilla/fireplace.git',
  }

  file {
    "${fireplace_dir}/deploysettings.py":
      require => Git::Clone[$fireplace_dir],
      content => template('marketplace/apps/fireplace/deploysettings.py');
  }

  dreadnot::stack {
    $domain:
      require       => File["${fireplace_dir}/deploysettings.py"],
      instance_name => $dreadnot_instance,
      github_url    => 'https://github.com/mozilla/fireplace',
      git_url       => 'git://github.com/mozilla/fireplace.git',
      project_dir   => $fireplace_dir;
  }
}
