# uwsgi instance.
define uwsgi::instance(
    $app_dir,
    $appmodule,
    $port,
    $home, # point at venv
    $user,
    $workers = 4,
    $environ = '',
    $log_syslog = true
) {
    include uwsgi

    $app_name = $name
    $pid_file = "${uwsgi::pid_dir}/${app_name}.pid"
    $sock_file = "${uwsgi::pid_dir}/${app_name}.sock"

    file {
        "${uwsgi::conf_dir}/${app_name}.ini":
            require => Class['uwsgi'],
            content => template('uwsgi/uwsgi.ini');
    }
    supervisord::service {
        "uwsgi-${app_name}":
            require    => File["${uwsgi::conf_dir}/${app_name}.ini"],
            command    => "/usr/bin/uwsgi ${uwsgi::conf_dir}/${app_name}.ini",
            app_dir    => '/tmp',
            environ    => $environ,
            stopsignal => 'INT',
            user       => $user;
    }

    nginx::upstream_unix {
        "uwsgi_${app_name}":
            require       => Supervisord::Service["uwsgi-${app_name}"],
            upstream_file => $sock_file;
    }

    motd {
        "2-uwsgi-${app_name}":
            order   => 12,
            content => "    ${app_name} is hosted at uwsgi://127.0.0.1:${port}/ (${app_dir})\n";
    }
}
