#  meteor-nodejs
Based on Offical CentOS image from **centos:centos7**

This Dockerfile stands for a **JavaScript Runtime and App Platform** where you can develop decentralized applications (Dapps) bundled as single html file connected to an running ethereum node with **JavaScript web3 API** communicating internally via **JSON RPC API**.

- Build context: 333 MByte
- DockerHub: <https://hub.docker.com/r/blakeberg/meteor-nodejs>
- Image Size: 1.108 GByte

## Installed packages
* openssh-server
* sudo
* passwd
* git
* curl
* nodejs *(with solc, web3 and meteor-build-client)*
* meteor

## Building & Running
Pull from dockerhub:

    docker pull blakeberg/meteor-nodejs

or copy the sources to your docker host.

### Build
	docker build --force-rm -t blakeberg/meteor-nodejs .

### Run
You can choose to run this container with or without a link to an Ethereum client geth.
#### without geth

	docker run -d -h meteor --name meteor -p 10022:22 -p 3000:3000 blakeberg/meteor-nodejs

#### with geth 
Container blakeberg/ssh:geth-node exists and is running.

	docker run -d -h meteor --name meteor -p 10022:22 -p 3000:3000 --link=geth:geth blakeberg/meteor-nodejs

> You will need this link for developing decentralized applications with Ethereum.

### Connect 
If you are connected to this container you can connect to linked container `geth` too. 

> If you us boot2docker you shoud add to your /etc/hosts under Windows or Mac OS X the IP and host name of the boot2docker VM `192.168.99.100 meteor` (IP to verify)

>If you have an issue with cross origin requests you can allow all domains with parameter `--rpccorsdomain "*"` and if you can't connect to geth node you can allow all adresses with parameter `--rpcaddr "0.0.0.0"`. Both parameters can be set with geth command see container geth-node *(link below)*

#### to this container
Connect with ssh use the port that was just located:

	ssh -p 10022 meteor@localhost

* initial passwd @see Dockerfile
* you can use sudo @ALL
* you can also connect via scp of course

#### to linked container
From this container you can connect to linked container `geth` via JSON RPC API:

    curl -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' http://geth:8545

If Ethereum node on geth is running you will get a JSON Response 

    {"id":67,"jsonrpc":"2.0","result":"Geth/v1.3.5/linux/go1.5.1"}

## Meteor
Meteor is a full stack JavaScript App Platform used for creating Apps and Dapps (in case of Blockchain / Ethereum). 

### Sample App
Create a new dummy-app within a running container. 

1. connect with ssh
2. create app dummy: `meteor create --release 1.2.1 dummy-app` *(first meteor is installing)*
3. change dir: `cd dummy-app`
4. start app dummy: `nohup meteor &`
5. show app in browser: `http://meteor:3000` 

**For a more sophisticated example complete the todo app!** *(link below)*

### Sample Dapp
A Dapp contains one or more contracts and a graphical user interface (UI) to handle it. There are some packages for Meteor includig UI you can simply use for that purpose.

#### create own
Create a new dummy-dapp within a running container.
Approve that container blakeberg/ssh:geth-node exists, is linked and its Ethereum client is running.

1. connect with ssh
2. create app dummy: `meteor create --release 1.2.1 dummy-dapp` *(first meteor is not installing if you done the dummy-app before)*
3. change dir: `cd dummy-dapp` 
4. install meteor packages for ethereum *(every package show its dependencies and a description if available)*
	* Ethereum JS API: `meteor add ethereum:web3`
	* helper functions: `meteor add ethereum:tools`
	* basic ui elements: `meteor add ethereum:elements`
	* CSS/LESS framework for dapps: `meteor add ethereum:dapp-styles` needs also `meteor add less`
	* Ethereum Accounts: `meteor add ethereum:accounts`
	* Ethereum Blocks: `meteor add ethereum:blocks`
5. add line `@import '{ethereum:dapp-styles}/dapp-styles.less';` to `dummy-dapp.css`
6. rename `mv dummy-dapp.css dummy-dapp.less`
7. start app dummy: `nohup meteor &`
8. everything you edit in js, html, css will changed directly in your browser `http://meteor:3000` *(you can only run one meteor instance on that port)*
9. Try some stuff from ethereum packages *(link below)*

#### run example
This example is included in this container and show at least on use case for each Meteor package for Ethereum. Approve that container blakeberg/ssh:geth-node exists, is linked and its Ethereum client is running.

1. run step 1-8 of create own sample dapp
2. copy files `cp ~/dummy-dapp.* .`
3. show again in your browser `http://meteor:3000` *(should updated immediately)*

> You see see the result "Hello World!" from sample contact "Greeter" `greeter.greet()` as example in container geth-node *(link below)*

### Bundle (D)Apps
With Meteor Build Client you can bundle the client part of a Meteor app with a simple index.html and javascript (and maybe css and images), so it can be hosted on any server or even loaded via the file:// protocol.

> Note that the Build Client could not executed successful for Meteor 1.3 projects so that is the reason why there built with option `--release 1.2.1`

**There is no need for centralized server!**

1. connect with ssh 
2. change dir: `cd dummy-app`
3. bundle app: `meteor-build-client ../bundled-dummy-app -p ""`
4. change dir: `cd ../bundled-dummy-app` and see *(there is only a html and js file)*
5. change dir: `cd ~/dummy-dapp`
6. bundle dapp: `meteor-build-client ../bundled-dummy-dapp -p ""`
7. change dir: `cd ../bundled-dummy-dapp` and see *(there is an additional css file and packages folder with images inside)*

See bundled (d)apps examples:

- <https://github.com/blakeberg/meteor-nodejs/tree/master/bundled-dummy-app> 
- <https://github.com/blakeberg/meteor-nodejs/tree/master/bundled-dummy-dapp>

>You can download these files and run via the file:// protocol. The dapp need a running geth-node *(link below)*

## NodeJS
NodeJS is a JavaScript Runtime Environment with Package Manager NPM which installed the Packages solc, web3 and also meteor-build-client described before. Approve that container blakeberg/ssh:geth-node exists, is linked and its Ethereum client is running.

### with solc
You can also compile contracts with solc from NodeJS as a javascript console type `node`.

Load solc module:

    var solc = require('solc');
	solc.version();

Compile contract greeter:

	var greeter = solc.compile("contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }");
	greeter.contracts.greeter.gasEstimates; 
	greeter.contracts.mortal.gasEstimates; 
  

### with web3
You can also execute JavaScript with web3.js from NodeJS as a javascript console type `node`.

Load web3 module and connect to Ethereum client:

    var Web3 = require('web3');
	var web3 = new Web3();
	web3.setProvider(new web3.providers.HttpProvider('http://geth:8545'));

Get account information:

	var coinbase = web3.eth.coinbase;
	coinbase; 
	web3.eth.getBalance(coinbase);

Call contract greeter (as in dapp example above):

	var abi = [{"constant":false,"inputs":[],"name":"kill","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"type":"constructor"}]; 
	var greeter = web3.eth.contract(abi).at("0x0608616212f0356c3d4c7c7b1c317151646164e1");
	greeter.greet();

## Useful Links
* Meteor Example App Handson <https://www.meteor.com/tutorials/blaze/creating-an-app>
* Install Meteor <https://www.meteor.com/install>
* Meteor API <http://docs.meteor.com/#/basic/>
* Meteor Build Client <https://github.com/frozeman/meteor-build-client>
* Ethereum Dapp using Meteor <https://github.com/ethereum/wiki/wiki/Dapp-using-Meteor>
* Ethereum Meteor Packages <https://atmospherejs.com/ethereum>
* Ethereum JavaScript web3 API <https://github.com/ethereum/web3.js/tree/master> and <https://github.com/ethereum/wiki/wiki/JavaScript-API>
* Ethereum JSON RPC API <https://github.com/ethereum/wiki/wiki/JSON-RPC>
* Ethereum Container <https://github.com/blakeberg/geth-node>
* NPM-Package solc <https://www.npmjs.com/package/solc>
* NPM-Package web3 <https://www.npmjs.com/package/web3>