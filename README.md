Knife HP
========

This is the official Opscode Knife plugin for HP Cloud. This plugin gives knife the ability to create, bootstrap and manage instances in the HP Cloud.

# Installation #

Be sure you are running the latest version Chef. Versions earlier than 0.10.0 don't support plugins:

    $ gem install chef

This plugin currently depends on HP's fork of Fog. To install it, run:

    $ cd /tmp
    $ wget http://build.hpcloud.com/sites/default/files/downloads/hpfog_2.tar
    $ tar -xf hpfog_2.tar
    $ gem install ./hpfog-0.0.14.gem

This plugin is distributed as a Ruby Gem, but is not available on Rubygems.org because of the missing Fog dependencies. To install it, run:

    $ cd /tmp
    $ git clone -b 0.1.0 git://github.com/mattray/knife-hp.git
    $ cd knife-hp
    $ gem build knife-hp.gemspec
    $ gem install knife-hp-0.1.0.gem

Depending on your system's configuration, you may need to run this command with root privileges.

# Configuration #

In order to communicate with HP Compute Cloud's API you will need to tell Knife the account ID, the secret key and tenant ID (you may also override the auth URI and availability zone. The easiest way to accomplish this is to create these entries in your `knife.rb` file:

    knife[:hp_account_id] = "Your HP Cloud account ID"
    knife[:hp_secret_key] = "Your HP Cloud secret key"
    knife[:hp_tenant_id]  = "Your HP Cloud tenant ID"
    knife[:hp_auth_uri]   = "Your HP Cloud Auth URI" (optional, default is "https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/")
    knife[:hp_avl_zone]   = "Your HP Cloud Availability Zone" (optional, default is "az1")

If your knife.rb file will be checked into a SCM system (ie readable by others) you may want to read the values from environment variables:

    knife[:hp_account_id] = "#{ENV['HP_ACCOUNT']}"
    knife[:hp_secret_key] = "#{ENV['HP_SECRET]}"
    knife[:hp_tenant_id]  = "#{ENV['HP_TENANT]}"
    knife[:hp_auth_uri]   = "#{ENV['HP_AUTH]}"
    knife[:hp_avl_zone]   = "#{ENV['HP_AVL_ZONE]}"

You also have the option of passing your HP Cloud API options from the command line:

    `-A` (or `--hp-account`) your HP Cloud Access Key ID
    `-K` (or `--hp-secret`) your HP Cloud Secret Key
    `-T` (or `--hp-tenant`) your HP Cloud Tenant ID
    `--hp-auth` your HP Cloud Auth URI (optional, default is "https://region-a.geo-1.identity.hpcloudsvc.com:35357/v2.0/")
    `-Z` (or `--hp-zone`) your HP Cloud Availability Zone (optional, default is "az1")

    knife hp server create -A 'MyUsername' -K 'MyPassword' -T 'MyTenant' -f 1 -I 13 -S hpkeypair -i ~/.ssh/hpkeypair.pem -r 'role[webserver]'

Additionally the following options may be set in your `knife.rb`:

* flavor
* image
* hp_ssh_key_id
* template_file

# Subcommands #

This plugin provides the following Knife subcommands. Specific command options can be found by invoking the subcommand with a `--help` flag

knife hp server create
----------------------

Provisions a new server in the HP Compute Cloud and then perform a Chef bootstrap (using the SSH protocol). The goal of the bootstrap is to get Chef installed on the target system so it can run Chef Client with a Chef Server. The main assumption is a baseline OS installation exists (provided by the provisioning). It is primarily intended for Chef Client systems that talk to a Chef Server. By default the server is bootstrapped using the [ubuntu10.04-gems](https://github.com/opscode/chef/blob/master/chef/lib/chef/knife/bootstrap/ubuntu10.04-gems.erb) template. This can be overridden using the `-d` or `--template-file` command options. If you do not pass a node name with `-N NAME` (or `--node-name NAME`) a name will be generated for the node.

    knife hp server create -f 1 -I 13 -S hpkeypair -i ~/.ssh/hpkeypair.pem

knife hp server delete
----------------------

Deletes an existing server in the currently configured HP Compute Cloud account. <b>PLEASE NOTE</b> - this does not delete the associated node and client objects from the Chef Server.

knife hp server list
--------------------

Outputs a list of all servers in the currently configured HP Compute Cloud account. <b>PLEASE NOTE</b> - this shows all instances associated with the account, some of which may not be currently managed by the Chef Server.

knife hp flavor list
--------------------

Outputs a list of all available flavors (available hardware configuration for a server) available to the currently configured HP Compute Cloud account. Each flavor has a unique combination of virtual cores, disk space and memory capacity. This data can be useful when choosing a flavor id to pass to the `knife hp server create` subcommand.

knife hp image list
-------------------

Outputs a list of all available images available to the currently configured HP Compute Cloud account. An image is a collection of files used to create or rebuild a server. Currently the list returned is unfiltered and does not match the view on the dashboard, images with "(Kernel)" and "(Ramdisk)" are not intended for use bootstrapping. This data can be useful when choosing an image id to pass to the `knife hp server create` subcommand.

# TODO #

This is a list of features currently lacking and (eventually) under development:

* filter out extraneous images from knife hp image list (requires HP metadata not yet available)
* do we need to release associated IP addresses for deleted servers?
* should the node.name and node.id be the same (might have to fix this in the ohai plugin)
* need ohai plugin to populate `cloud` and `hp` attributes from http://tickets.opscode.com/browse/OHAI-335
* take either the flavor ID or the flavor name
* take either the image ID or the image name
* show the flavor and image names in server lists

# License #

Author:: Matt Ray (<matt@opscode.com>)

Copyright:: Copyright (c) 2012 Opscode, Inc.

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
