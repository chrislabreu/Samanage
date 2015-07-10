#!/bin/bash

tmpdir=$(mktemp -d)
cd $tmpdir

sudo apt-get update
sudo apt-get -y install wget libxml-simple-perl libnet-ip-perl libdigest-hmac-perl  liblwp-protocol-https-perl dmidecode pciutils expect

wget http://cdn.samanage.com/download/Unix/Ocsinventory-Unix-Agent-2.1rc1.tar.gz -O - | tar xzfv -
cd Oc*

perl Makefile.PL
make

sudo date

sudo expect << 'EOF'

set timeout 20
spawn sudo make install

expect {
	"Do you want to configure the agent" {
		send "y\n"
		exp_continue
	}
	"Where do you want to write the configuration file?" {
		send "0\n"
		exp_continue
	}
	"Do you want to create the directory /etc/ocsinventory?" {
		send "y\n"
		exp_continue
	}
	"Should the old linux_agent settings be imported" {
		send "n\n"
		exp_continue
	}
	"What is the address of your ocs server?>" {
		send "inventory.samanage.com\n"
		exp_continue
	}
	"Do you need credential for the server?" {
		send "n\n"
		exp_continue
	}
	"Do you want to apply an administrative tag on this machine" {
		send "y\n"
		exp_continue
	}
	"tag?>" {
		send "Makerbot\n"
		exp_continue
	}
	"Do yo want to install the cron task in /etc/cron.d" {
		send "y\n"
		exp_continue
	}
	"Where do you want the agent to store its files?" {
		send "/var/lib/ocsinventory-agent\n"
		exp_continue
	}
	"Do you want to create the /var/lib/ocsinventory-agent directory?" {
		send "y\n"
		exp_continue
	}
	"Should I remove the old linux_agent" {
		send "y\n"
		exp_continue
	}
	"Do you want to activate debug configuration option" {
		send "y\n"
		exp_continue
	}
	"Do you want to use OCS Inventory NG UNix Unified agent log file" {
		send "y\n"
		exp_continue
	}
	"Specify log file path you want to use?>" {
		send "/var/log/ocsinventory.log\n"
		exp_continue
	}
	"Do you want disable SSL CA verification configuration option (not recommended) ?" {
		send "n\n"
		exp_continue
	}
	"Do you want to set CA certificate chain file path" {
		send "n\n"
		exp_continue
	}
	"Do you want to use OCS-Inventory software deployment feature?" {
		send "y\n"
		exp_continue
	}
	"Do you want to use OCS-Inventory SNMP scans feature?" {
		send "y\n"
		exp_continue
	}
	"Do you want to send an inventory of this machine?" {
		send "y\n"
		exp_continue
	}
}
EOF

cd -
rm -rf $tmpdir