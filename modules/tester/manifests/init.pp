class tester (
	$install_path = "/usr/local/src/phpunit",
	$tester_config = sz_load_config()
) {
	# Create the install path
	file { $install_path:
		ensure => directory,
	}

	if $tester_config[php] < 5.6 {
		$phpunit_repo_url = "https://phar.phpunit.de/phpunit-5.7.phar"
	} else {
		$phpunit_repo_url = "https://phar.phpunit.de/phpunit-4.8.phar"
	}

	# Download phpunit
	exec { "phpunit download":
		command => "/usr/bin/curl -o $install_path/phpunit.phar -L $phpunit_repo_url",
		require => [ Package[ 'curl' ], File[ $install_path ] ],
		creates => "$install_path/phpunit.phar",
	}

	# Ensure we can run phpunit
	file { "$install_path/phpunit.phar":
		ensure  => "present",
		mode    => "a+x",
		require => Exec[ 'phpunit download' ]
	}

	# Symlink it across
	file { '/usr/bin/phpunit':
		ensure  => link,
		target  => "$install_path/phpunit.phar",
		require => File[ "$install_path/phpunit.phar" ],
	}

	if ( $tester_config[tester_db] ) {
		mysql::db { $tester_config[tester_db][name]:
			user     => $tester_config[tester_db][user],
			password => $tester_config[tester_db][password],
			host     => localhost,
			grant    => ['all'],
		}
	}
}
