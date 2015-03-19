
var system = require('system');
var args = system.args;

var page = new WebPage();
var testindex = 0, loadInProgress = false;

var pick = args[1];

page.onConsoleMessage = function(msg) {
  console.log(msg);
};

page.onLoadStarted = function() {
  loadInProgress = true;
};

page.onLoadFinished = function() {
  loadInProgress = false;
  showCookies();
};


var steps = [
  function() {
    //Load Login Page

    page.open("http://m.espn.go.com/mobile/apps/reg/login");

  },
  function() {
    //Enter Credentials
    page.evaluate(function() {

      var arr = document.getElementsByName("username");
      var i;
      for (i=0; i < arr.length; i++) { 
          arr[i].value = 'ggggooooggggoooo';
      }
      var bee = document.getElementsByName("gspw");
      for (i=0; i < bee.length; i++) { 
          bee[i].value = 'ggooggoo';
      }
    });
  }, 
  function() {
    //Login
    page.evaluate(function() {
      var arr = document.getElementById("loginBtn");
      arr.click();
    });
  }, 
  function() {
      // make pick
    page.open("http://streak.espn.go.com/en/createOrUpdateEntry?matchup=" + pick );
  },
  function() {
  // need an empty function here to make sure the previous load completes
      }
];

function showCookies() {
  for (var i in page.cookies) {
    console.log(page.cookies[i].name);
    console.log(page.cookies[i].value);
          }
};

interval = setInterval(function() {
  if (!loadInProgress && typeof steps[testindex] == "function") {
    steps[testindex]();
    testindex++;
  }
  if (typeof steps[testindex] != "function") {
    phantom.exit();
  }
}, 50);


