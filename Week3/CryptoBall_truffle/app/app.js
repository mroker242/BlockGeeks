$(document).on('click', '.btn', function(){


  contract.claimFreeBaller()
  .then(function(res) { console.log(res) })
  .catch(function(err){console.log('You already claimed your freeballer!') })

  console.log(contract.ballers(0));

  contract.ballers(0).then(function(data){
    console.log(data);
    console.log('Name: ' + data.name);
    console.log('level: ' +data.level);
    console.log('Offenive skill: ' + data.offenseSkill);
    console.log('Defensive skill: ' + data.defenseSkill);

  })



  //console.log(contract.ballers.length);

  //console.log(contract.ballers[0]);
})

$(document).ready(function(){
  // contract.getNumBallers().then(function(data){
  //   console.log(data);
  // });


  showBallers(0);






}); //end document ready

function showBallers(id){
  contract.ballers(id).then(function(data){
    var html = '<div><ul><li>Name: ' + data.name + '</li><li>Level: ' + data.level + '</li><li>OffenseSkill: ' + data.offenseSkill + '</li><li>Defense Skill: ' + data.defenseSkill + '</li></ul></div>' ;
    $('body').append(html);
  })
}

function buyBaller(){
  contract.buyBaller();
}

// function showBallers(){
//   for (i = 0; i < contract.ballers.length; i++){
//     console.log(ballers[i]);
//   }
// }

function showFee(){
  contract.ballerPrice().then(function(data){
    console.log(data);
  })
}



//console.log(web3);
