#!/usr/bin/env bash

#### Extra breathing room
echo -e '\n'

testPostfixUsername()
{
	echo 'Testing Postfix username'
	test=$(/usr/sbin/postconf smtp_sasl_password_maps | grep 'p08tf1X' | wc -l)
	assertEquals 1 $test
	echo -e '\n'
}


testPostfixPassword()
{
	echo 'Testing Postfix password'
	test=$(/usr/sbin/postconf smtp_sasl_password_maps | grep 'p@ssw0Rd' | wc -l)
	assertEquals 1 $test
	echo -e '\n'
}


testPostfixRelay()
{
	echo 'Relay through SendGrid'
	test=$(/usr/sbin/postconf relayhost | grep 'htmlgraphic' | wc -l)
	assertEquals 1 $test
	echo -e '\n'
}


testHTTP()
{
	echo 'Test Apache HTTP'
	test=$(/usr/bin/wget -q -O- http://127.0.0.1 | grep -w "Hello World\\!" | wc -l)
	assertEquals 1 $test
	echo -e '\n'
}


testHTTPS()
{
	echo 'Test Apache HTTPS'
	test=$(/usr/bin/wget -q -O- --no-check-certificate https://127.0.0.1 | grep -w "Hello World\\!" | wc -l)
	assertEquals 1 $test
	echo -e '\n'
}


testNODE_ENVIRONMENT()
{
	echo 'Test env NODE_ENVIRONMENT, currently set to "'$NODE_ENVIRONMENT'"'
	node_env=false;

	# Depending on the type of environment dev or production an
	# environmental variable should be set
	if [[ "${NODE_ENVIRONMENT}" == 'dev' ]] || [[ "${NODE_ENVIRONMENT}" == 'production' ]]; then
		node_env=true;
	fi
	assertTrue $node_env
	echo -e '\n'
}

testNODE_ENVIRONMENT_PHP()
{
	echo 'Test env NODE_ENVIRONMENT within Apache'
	node_env=false;
	dev=$(/usr/bin/wget -q -O- http://127.0.0.1 | grep -w "NODE_ENVIRONMENT=dev" | wc -l);
	prod=$(/usr/bin/wget -q -O- http://127.0.0.1 | grep -w "NODE_ENVIRONMENT=production" | wc -l)

	# Depending on the type of environment dev or production an
	# environmental variable should be set
	if [[ $dev == 1 ]] || [[ $prod == 1 ]]; then
		node_env=true;
	fi
	assertTrue $node_env
	echo -e '\n'
}

. /opt/tests/shunit2-2.1.6/src/shunit2
