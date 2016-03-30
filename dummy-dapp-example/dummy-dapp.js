if (Meteor.isClient) { 
  if(typeof web3 === 'undefined') {
    web3 = new Web3(new Web3.providers.HttpProvider('http://geth:8545'));
  }
  // counter starts at 0
  EthBlocks.init();
  EthAccounts.init();
  
  var abi = [{"constant":false,"inputs":[],"name":"kill","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"greet","outputs":[{"name":"","type":"string"}],"type":"function"},{"inputs":[{"name":"_greeting","type":"string"}],"type":"constructor"}];
  var greeter = web3.eth.contract(abi).at("0x0608616212f0356c3d4c7c7b1c317151646164e1");
  
  Template.elements.helpers({
    currentBlock: function(){
      return EthBlocks.latest.number;
    },
    accounts: function () {
      return EthAccounts.find().fetch();
    },
    greeter: function () {
        return greeter.greet();
    }
  });
  
  Template.elements.events({
    'click button.modal': function(){
      // show modal
      EthElements.Modal.show('modal_demo');
    },
    'click button.question-modal': function(){
      // show modal
      EthElements.Modal.question({
        text: 'Are you ok?',
        ok: function(){
          alert('Very nice!');
        },
        cancel: true
      });
    },
    'click button.question-modal-template': function(){
      // show modal
      EthElements.Modal.question({
        template: 'modal_demo',
        ok: function(){
          alert('Lorem ipsum!');
        },
        cancel: function(){
          alert('Ok Bye!');
        }
      });
    }
  });
}

if (Meteor.isServer) {
  Meteor.startup(function () {
    // code to run on server at startup
  });
}
