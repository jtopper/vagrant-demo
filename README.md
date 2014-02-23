# Demo Vagrant environment

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

## Next steps

Refer to the Vagrant and Puppet documentation for more information.

