#  meteor-nodejs
Based on <https://github.com/fedora-cloud/Fedora-Dockerfiles> ported by Adam Miller from **centos:centos7**

This Dockerfile stands for a **JavaScript Runtime and App Platform** where you can develop decentralized applications bundled as single html file connected to an running ethereum node with **JavaScript web3 API** communicating internally via **JSON RPC API**.

Image size: 860,3 MByte

## Installed packages
* openssh-server
* sudo
* nodejs
* meteor
* meteor-build-client

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
JavaScript App Platform used for creating decentralized Apps (dapps) with Ethereum.

### First App
Create a new dummy app within a running container. 

1. connect with ssh
2. create app dummy: `meteor create dummy` (first meteor is installing)
3. change dir: `cd dummy`
4. start app dummy: `nohup meteor &`
5. show app in browser: `http://localhost:13000` (or IP of the VM if you use boot2docker)

### Bundle App

With Meteor Build Client you can bundle the client part of a Meteor app with a simple index.html, so it can be hosted on any server or even loaded via the file:// protocol.

**There is no need for centralized server!**

1. connect with ssh
2. change dir: `cd dummy`
3. bundle app: `meteor-build-client ../dummy-bundled`
4. change dir: `cd ../dummy-bundled`
5. `chmod g+x` for created js file

See example <https://github.com/blakeberg/meteor-nodejs/tree/master/bundled-dummy-app>

## Useful Links
* Meteor Example App Handson <https://www.meteor.com/tutorials/blaze/creating-an-app>
* Install Meteor <https://www.meteor.com/install>
* Meteor API <http://docs.meteor.com/#/basic/>
* Meteor Build Client <https://github.com/frozeman/meteor-build-client>
* Ethereum JavaScript web3 API <https://github.com/ethereum/web3.js/tree/master> and <https://github.com/ethereum/wiki/wiki/JavaScript-API>
* Ethereum JSON RPC API <https://github.com/ethereum/wiki/wiki/JSON-RPC>