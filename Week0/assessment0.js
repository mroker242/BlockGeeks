/*
  # 1. repeatNumbers function: input array of numbers
  format: [1,10] second number repeats first 10 times
*/
function repeatNumbers(numbers){

  stringr = '';
  result = [];

  var dupli = function(numbers){
    s = ''
    for (m = 0; m < numbers[1]; m++){
      s += numbers[0];
    }
    return s
  };


  for (i = 0; i < numbers.length; i++){
    result.push(dupli(numbers[i]));
  };

  return result;

};

/*
  # 2. functionalSum functions: input array of numbers and 'even' or 'odd'
*/
function conditionalSum(arr, evenOdd){
  counter = 0;

  function isEven(num){
    return num % 2 === 0;
  };

  function isOdd(num){
    return num % 2 != 0;
  };

  if (evenOdd == 'even'){

    for (i = 0; i < arr.length; i++){
      if (isEven(arr[i])){
        counter += arr[i];
      };
    };

  }else{
      for (i = 0; i < arr.length; i++){
        if (isOdd(arr[i])){
          counter += arr[i];
        };
      };
    };

  return counter;
};


/*

  Talking Calendar

*/

function talkingCalendar(date){

  months = [{'01':'january',
            '02':'Februrary',
            '03':'March',
            '4':'April',
            '5':'May',
            '6':'June',
            '7':'July',
            '08': 'August',
            '9': 'September',
            '10': 'October',
            '11': 'November',
            '12': 'December'
          }];


  abbr = [{'1': 'st',
          '02': 'nd',
          '3': 'rd'
          }];

  dateParse = date.split('/');

  var year = dateParse[0];
  var month = dateParse[1];
  var day = dateParse[2];

  display = '';
  for (var i = 0; i < months.length;i++){
    if(month in months[i]){
      display += months[i][month];
    }
  }
  // Add ending onto day
  for (var p = 0; p < abbr.length; p++){
    //console.log('Day: ' + day);
    //console.log('Variable: ' + abbr[p]);
    if(day in abbr[p]){
      display += ' ';
      display += day;
      display += abbr[p][day];
    } else if (!(day in abbr[p])){
      display += ' ';
      display += day;
      display += 'th';
      break;
    }
  }

  //adding comma
  display += ', ';
  display += year;

  return display;

};



/*
 4. Calculate Change
*/


function calculateChange(cash, total){

  var simpleObject = {};
  money = {
    'penny' : 1,
    'nickel' : 5,
    'dime' : 10,
    'quarter' : 25,
    'dollar' : 100,
    'twoDollar' : 200,
    'fiveDollar' : 500,
    'tenDollar' : 1000,
    'twentyDollar' : 20000
  };


  // return the cash minus the total which is the change.
  function easyCalc(total, cash){
    return cash - total;
  }

  cash = easyCalc(cash, total);

  // logic for calculation
  function checkNotes(cash, simpleObject){
    if (cash >= money['twentyDollar']){
      cash  -= money['twentyDollar'];
      transaction('twenty_d', simpleObject);
    } else if(cash >= money['tenDollar']){
      cash  -= money['tenDollar'];
      transaction('tenDollar', simpleObject);
    } else if (cash >= money['fiveDollar']) {
      cash  -= money['fiveDollar'];
      transaction('five_d', simpleObject);
    } else if (cash >= money['twoDollar']){
      cash  -= money['twoDollar'];
      transaction('twoDollar', simpleObject);
    } else if (cash >= money['dollar']){
      cash -= money['dollar'];
      transaction('dollar', simpleObject);
    } else if (cash >= money['quarter']){
      cash -= money['quarter'];
      transaction('quarter', simpleObject);
    } else if (cash >= money['dime']){
      cash -= money['dime'];
      transaction('dime', simpleObject);
    } else if (cash >= money['nickel']){
      cash -= money['nickel'];
      transaction('nickel', simpleObject);
    } else if (cash >= money['penny']){
      cash -= money['penny'];
      transaction('penny', simpleObject);
    }
    return cash;
  };


  while (cash > 0){
    cash = checkNotes(cash, simpleObject);
  };


  function transaction(note, simpleObject){
    if (note in simpleObject){
      simpleObject[note] += 1;
    } else{
      simpleObject[note] = 1;
    }
  return simpleObject;
  }

return simpleObject;
};
