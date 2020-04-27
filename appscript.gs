//Week 4
var SHEET_ID = "1BoOWC5I_KnKarh7OdAoiFLfiR7QSp4vniY_pLWOlWmE";
var PLAYERS = 36;
var ACTIVITIES = 14;
var TEAMS = 9;

//Week 2
//var SHEET_ID = "1df35IPpiPfLy3ttMn4OPInUyoqpk42meXkN8IMY5KNo";

//week 3, doesn't work
//var SHEET_ID = "1-KrNloE4lPPRa-PmT0-_b5NAV3oj5S-PiyNzBc3Eljo";

function doGet(request){
    try{
      var result = {"status": "SUCCESS"};
      
      // Get all Parameters
      var type = request.parameter.type;
      Logger.log(type);
      switch(type) {
        case "getNames":
          var names = getNames();
          result.names = names;
          break;
        case "getWorkouts":
          var workouts = getWorkouts();
          result.workouts = workouts;
          break;
        case "update":
          var cell = request.parameter.cell;
          var value = Number(request.parameter.value);
          update(cell, value);
          break;
        case "getLeaderboard":
          var leaderboard = getLeaderBoard();
          result = leaderboard;
          break;
        case "getTeams":
          var teams = getTeams();
          result = teams;
        default:
          Logger.log("Got unknown type " + type);
      }

    }catch(exc){
      Logger.log("Error occurred");
      return ContentService
      .createTextOutput(JSON.stringify({"Error": exc}))
        .setMimeType(ContentService.MimeType.JSON);
    }

    // Return result
    return ContentService
        .createTextOutput(JSON.stringify(result))
        .setMimeType(ContentService.MimeType.JSON);
}

function getWorkouts() {
  // Open Google Sheet using ID
  var sheet = SpreadsheetApp.openById(SHEET_ID);
  var startChar = 'C';
  var endChar = String.fromCharCode(startChar.charCodeAt(0) + ACTIVITIES - 1);
  Logger.log("endChar is " + endChar);
  var range = sheet.getRange(startChar+"2:"+endChar+"2");
  var unitsRange = sheet.getRange(startChar+"3:"+endChar+"3");
  Logger.log(range.getValues());
  var workouts = range.getValues()[0];
  var units = unitsRange.getValues()[0];
  var workoutsWithIndex = workouts.map(function(workout, index){
    return {"workout": workout, "units": units[index], "index": String.fromCharCode(startChar.charCodeAt(0) + index)}
  })
  return workoutsWithIndex;
}

function getNames() {
  // Open Google Sheet using ID
  var sheet = SpreadsheetApp.openById(SHEET_ID);
  var range = sheet.getRange("B4:B"+(PLAYERS+3));
  Logger.log(range.getValues());
  var names = range.getValues();
  var namesWithIndex = names.map(function(name, index){return {"name": name[0], "index": (index + 4)}})
  return namesWithIndex;
}

function update(cell, value){
  var sheet = SpreadsheetApp.openById(SHEET_ID);
  var range = sheet.getRange(cell);
  var existingValue = Number(range.getValue());
  Logger.log(existingValue);
  var newValue = existingValue + value;
  Logger.log(newValue);
  range.setValue(newValue)
}

function getLeaderBoard(){
  var sheet = SpreadsheetApp.openById(SHEET_ID);
  var leaderboardSheet = sheet.getSheetByName("Leaderboard");
  var individualsComputedRange = "A2:C"+(PLAYERS+1);
  var teamsComputedRange = "E2:G"+(TEAMS+1);
  
  var individualRange = leaderboardSheet.getRange(individualsComputedRange);
  var individualRanks = individualRange.getValues();
  
  var teamRange = leaderboardSheet.getRange(teamsComputedRange);
  var teamRanks = teamRange.getValues();
  
  var individuals = individualRanks.map(function(tuple, index){
    var score = tuple[2];
    if(score === "#N/A") {
      score = 0.00;
    }
    return {"rank": tuple[0], "name": tuple[1], "score": Number(score.toFixed(2))}
  })
  
  var teams = teamRanks.map(function(tuple, index){
    var score = tuple[2];
    var team = tuple[1];
    if(score === "#N/A") {
      score = 0.00;
    }
    if(team === "#N/A") {
      team = 0;
    }
    return {"rank": tuple[0], "name": team.toString(), "score": Number(score.toFixed(2))}
  })
  
  return {"individuals": individuals, "teams": teams};
}

function getTeams() {
  // Open Google Sheet using ID
  var sheet = SpreadsheetApp.openById(SHEET_ID);
  var range = sheet.getRange("A4:B"+(PLAYERS+3));
  Logger.log(range.getValues());
  var teamMap = {};
  var teamRange = range.getValues();
  teamRange.forEach(function(tuple, index)
  {
    var teamNumber = tuple[0].toString();
    var playerName = tuple[1];
    if(teamMap[teamNumber]){
      teamMap[teamNumber].push(playerName)
    } else {
      teamMap[teamNumber] = [playerName];
    }
  });
  var teams = [];
  Object.keys(teamMap).forEach(function(teamNumber){
    teams.push({"teamName": teamNumber, "members": teamMap[teamNumber]});
  })
  return teams;
}