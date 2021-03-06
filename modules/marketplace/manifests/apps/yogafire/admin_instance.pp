# $name is the location of yogafire
define marketplace::apps::yogafire::admin_instance(
  $cluster,
  $domain,
  $dreadnot_instance,
  $env,
  $ssh_key,
  $zamboni_dir,
  $project_name = 'yogafire',
) {
  $yogafire_dir = $name

  git::clone { $yogafire_dir:
    repo => 'https://github.com/mozilla/yogafire.git',
  }

  file {
    "${yogafire_dir}/deploysettings.py":
      require => Git::Clone[$yogafire_dir],
      content => template('marketplace/apps/yogafire/deploysettings.py');
  }

  dreadnot::stack {
    $domain:
      require       => File["${yogafire_dir}/deploysettings.py"],
      instance_name => $dreadnot_instance,
      github_url    => 'https://github.com/mozilla/yogafire',
      git_url       => 'git://github.com/mozilla/yogafire.git',
      project_dir   => $yogafire_dir;
  }
}
