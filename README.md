# Demo Vagrant environment

This is the demo repository that relates to my PuppetCamp presentation at https://puppetlabs.com/presentations/puppet-camp-london-fall-2014-getting-started-puppet-and-vagrant

## What is it?

Vagrant is a tool used to create and configure lightweight, reproducible, and portable development environments.  We use Vagrant in combination with Puppet to put together a development environment which closely matches production servers.

## What do I need?

You'll need to install:

 * [Vagrant](http://vagrantup.com)
 * [VirtualBox](http://www.virtualbox.org/)

These are both packaged pieces of software, available for Linux, Mac and Windows.  Most of our work with Vagrant is tested on Mac and Linux, and this guide (as well as the configuration supplied) assumes you're using one of these.

If you have the commercial Vagrant plugin for working with VMWare (instead of Virtualbox), this configuration will work with that provider too.

## Getting started

Once you've got the prerequisites installed, create a folder to work in:

```
mkdir -p ~/Vagrant
cd $!
```

You'll need to clone the demo project into that folder:

```
git clone git@github.com:jtopper/vagrant-demo.git
cd vagrant-demo
```

Try running ```vagrant status```.  You should see something like:

```
$ vagrant status
Current machine states:

default                   not created (virtualbox)

The environment has not yet been created. Run `vagrant up` to
create the environment. If a machine is not created, only the
default provider will be shown. So if a provider is not listed,
then the machine is not created for that environment.
```

## Bringing up the Vagrant box

To get the machine up and running, do

```
vagrant up
```

The first time you run this, it will fetch a Vagrant base box image (around 600MB) from the internet.

The virtual machine will then start in the background, and then start running the Puppet manifests.  This will download and installs packages, and configure services.  Once complete, you should be able to browse to http://10.8.8.10/ and see a web page served by the Vagrant box.

## Logging in

You can get a shell on the Vagrant box by running

```
vagrant ssh
```

From there you have full sudo access to the running server.

## Re-run Puppet

To re-run Puppet in the Vagrant box, from the guest run:

```
vagrant provision
```

## Stop the virtual machine

```
vagrant halt
```

## Delete the virtual machine completely

```
vagrant destroy
```

## Demo

If you're following along with the PuppetCamp video: 

(20:38) After starting the vagrant box initially, visit http://10.8.8.10/ and you should see the output from a call to phpinfo().

(20:58) Then visit http://10.8.8.10/ping.php and you should see a page containing the MySQL status. From an initial checkout of this repository, the page will report that the mysql_connect function is failing.

(21:17) I open `puppet/environments/vagrant/modules/demo_php/manifests/init.pp`, which is one of the modules that puppet runs on the demo VM.  In this contrived example, we find that there's no PHP MySQL module installed.

(21:21) I add the package resource to the Puppet manifest and save the file.  `package { "php-mysql": }`

(22:07) I run the provisioner to apply the change: `vagrant provision`

(22:38) I re-run the provisioner to demonstrate that no further changes are made `vagrant provision`

(23:00) I reload the http://10.8.8.10/ping.php page and see that there's a different error now (MySQL not running)

(23:07) I connect to the Vagrant box using `vagrant ssh` and run `ps auxwwf | grep mysql` to see if MySQL is running (it isn't)

(23:22) I check to see if this is because the MySQL package isn't installed with `rpm -qa | grep mysql` and see that mysql-server is present, thus ruling out that this is the problem. It must just be that the service isn't running.

(23:29) I exit the vagrant ssh shell with Ctrl-D to get back to my host machine

(23:33) I open the Puppet script for the database role module `puppet/environments/vagrant/modules/demo_role_database/manifests/init.pp` and see that we're not attempting to start the service from there. 

(23:44) To enable the mysql service, "chained" (ie. to run after) the package install, I add this to the file and save it:
```
->
service { "mysql":
    ensure => running
}
```

(24:12) I re-run `vagrant provision` to apply my changes, but the change fails - the error message shows that I'm trying to start a service that doesn't exist.

(24:22) I open the database role module again and change the name of the service from `mysql` to `mysqld`, and save the file.

(24:28) I run the provisioner again with `vagrant provision`

(24:36) I reload http://10.8.8.10/ping.php page again and see a green "Yes!" to show everything is working.


## Next steps

Some things that are worth understanding:

 * The PHP application that runs the ping page is served from the Vagrant image, but using source files shared from the host system.  Figure out the relationship between the Vagrant shared folder and the configuration Puppet writes for the webserver. You may need to refer to the Vagrant documentation here (this is a default shared folder, so it isn't explicitly configured).
 * The Vagrantfile contains some magic to allow use of a local package mirror if one exists.  Make sure you understand how that lump of Vagrant config works, and how the Puppet fact it sets is made use of in the manifests.
 * Understand the order enforcement at the end of the demo_yum module (you'll need to refer to the Puppet docs for this)





