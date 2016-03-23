#  meteor-nodejs
Based on <https://github.com/fedora-cloud/Fedora-Dockerfiles> ported by Adam Miller from **centos:centos7**

Image size: 860,3 MByte

## Installed packages
* openssh-server
* sudo
* nodejs
* meteor
* meteor-build-client

## next steps
* run meteor build client

## Building & Running
Pull from dockerhub:

    docker pull blakeberg/ssh:meteor-nodejs

or copy the sources to your docker host.

### Build
	docker build --force-rm -t blakeberg/ssh:meteor-nodejs .

### Run
	docker run -d --name meteor -p 10022:22 -p 13000:3000 blakeberg/ssh:meteor-nodejs

### Connect 
Connect with ssh use the port that was just located:

	ssh -p 10022 meteor@localhost

* initial passwd @see Dockerfile
* you can use sudo @ALL
* you can also connect via scp of course

## Meteor
Create a new dummy app within a running container. 

1. connect with ssh
2. create app dummy: `meteor create dummy` (first meteor is installing)
3. change dir: `cd dummy`
4. start app dummy: `nohup meteor &`
5. show app in browser: `http://localhost:13000` (or IP of the VM if you use boot2docker)

## Useful Links
* Meteor Example App Handson <https://www.meteor.com/tutorials/blaze/creating-an-app>
* Install Meteor <https://www.meteor.com/install>
* Meteor API <http://docs.meteor.com/#/basic/>
* Meteor Build Client <https://github.com/frozeman/meteor-build-client>