class tester (
	$install_path = "/usr/local/src/phpunit",
) {
	# Create the install path
	file { $install_path:
		ensure => directory,
	}

	# Download phpunit
	exec { "phpunit download":
		command => "/usr/bin/curl -o $install_path/phpunit-old.phar -L https://phar.phpunit.de/phpunit-old.phar",
		require => [ Package[ 'curl' ], File[ $install_path ] ],
		creates => "$install_path/phpunit-old.phar",
	}

	# Ensure we can run phpunit
	file { "$install_path/phpunit-old.phar":
		ensure => "present",
		mode => "a+x",
		require => Exec[ 'phpunit download' ]
	}

	# Symlink it across
	file { '/usr/bin/phpunit':
		ensure => link,
		target => "$install_path/phpunit-old.phar",
		require => File[ "$install_path/phpunit-old.phar" ],
	}
}
