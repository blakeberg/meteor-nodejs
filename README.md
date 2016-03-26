#  meteor-nodejs
Based on <https://github.com/fedora-cloud/Fedora-Dockerfiles> ported by Adam Miller from **centos:centos7**

This Dockerfile stands for a **JavaScript Runtime and App Platform** where you can develop decentralized applications bundled as single html file connected to an running ethereum node with **JavaScript web3 API** communicating internally via **JSON RPC API**.

Image size: 860,3 MByte

## Installed packages
* openssh-server
* sudo
* passwd
* nodejs
* meteor
* meteor-build-client

## Building & Running
Pull from dockerhub:

    docker pull blakeberg/meteor-nodejs

or copy the sources to your docker host.

### Build
	docker build --force-rm -t blakeberg/meteor-nodejs .

### Run
You can choose to run this container with or without a link to an Ethereum client.
#### Run Container without Ethereum

	docker run -d -h meteor --name meteor -p 10022:22 -p 3000:3000 blakeberg/meteor-nodejs

#### Run Container with Ethereum 
Container blakeberg/ssh:geth-node exists and is running.

	docker run -d --name meteor -p 10022:22 -p 3000:3000 --link=geth:geth blakeberg/meteor-nodejs

### Connect 
If you are connected to this container you can connect to linked container `geth` too.
#### Connect to this container
Connect with ssh use the port that was just located:

	ssh -p 10022 meteor@localhost

* initial passwd @see Dockerfile
* you can use sudo @ALL
* you can also connect via scp of course

#### Connect to linked container
From this container you can connect to linked container `geth` via JSON RPC API:

    curl -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://geth:8545

If Ethereum node on geth is running you will get a JSON Response 

    {"id":67,"jsonrpc":"2.0","result":"Geth/v1.3.5/linux/go1.5.1"}

## Meteor
JavaScript App Platform used for creating decentralized Apps (dapps) with Ethereum.

### First App
Create a new dummy app within a running container. 

1. connect with ssh
2. create app dummy: `meteor create dummy` (first meteor is installing)
3. change dir: `cd dummy`
4. start app dummy: `nohup meteor &`
5. show app in browser: `http://localhost:3000` 

> if you use boot2docker, docker is configured to use the default machine with IP 192.168.99.100

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