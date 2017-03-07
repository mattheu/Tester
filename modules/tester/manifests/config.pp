class tester::config(
	$tester_db_name = 'tests',
	$tester_db_user = 'tester',
	$tester_db_password = 'vagrant_password',
	$tester_db_prefix = 'tests',
	$wpdir = 'wp',
	$contentdir = 'content'
) {
	file { "/vagrant/extensions/tester/wpdevel/wp-tests-config.php":
		content => template("tester/wp-tests-config.php.erb"),
	}

	file { '/vagrant/local-config-tester.php':
		content => template('tester/local-config-tester.php.erb')
	}

	file { "/etc/profile.d/tester-env.sh":
		content => template("tester/tester-env.sh.erb"),
	}
}
