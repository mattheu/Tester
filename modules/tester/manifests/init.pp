class tester (
	$install_path = "/usr/local/src/phpunit",
	$tester_config = sz_load_config()
) {
	# Create the install path
	file { $install_path:
		ensure => directory,
	}

	$phpunit_repo_url = "https://phar.phpunit.de/phpunit-4.8.phar"

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
}
