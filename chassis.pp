$tester_config = sz_load_config()

class {"tester": }
class {"tester::config":
	wpdir              => $tester_config[mapped_paths][wp],
	contentdir         => $tester_config[mapped_paths][content],
	tester_db_name     => $tester_config[tester_db][name],
	tester_db_user     => $tester_config[tester_db][user],
	tester_db_password => $tester_config[tester_db][password],
	tester_db_prefix   => $tester_config[tester_db][prefix]
}
