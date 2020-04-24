function doGet(request){
    try{
      var result = {"status": "SUCCESS123456"};
      
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
      }
      //var name = request.parameter.name;
      //var email = request.parameter.email;
      //var mobileNo = request.parameter.mobileNo;
      //var feedback = request.parameter.feedback;
      
      // Append data on Google Sheet
      //var rowData = sheet.appendRow([name, email, mobileNo, feedback]);  

    }catch(exc){
      // If error occurs, throw exception
      result = {"status": "FAILED", "message": exc};
    }

    // Return result
    return ContentService
    .createTextOutput(JSON.stringify(result))
    .setMimeType(ContentService.MimeType.JSON);
}

function getWorkouts() {
  // Open Google Sheet using ID
  var sheet = SpreadsheetApp.openById("1-KrNloE4lPPRa-PmT0-_b5NAV3oj5S-PiyNzBc3Eljo");
  var range = sheet.getRange("C2:P2");
  var unitsRange = sheet.getRange("C3:P3");
  Logger.log(range.getValues());
  var startChar = 'C';
  var workouts = range.getValues()[0];
  var units = unitsRange.getValues()[0];
  var workoutsWithIndex = workouts.map(function(workout, index){
    return {"workout": workout, "units": units[index], "index": String.fromCharCode(startChar.charCodeAt(0) + index)}
  })
  return workoutsWithIndex;
}

function getNames() {
  // Open Google Sheet using ID
  var sheet = SpreadsheetApp.openById("1-KrNloE4lPPRa-PmT0-_b5NAV3oj5S-PiyNzBc3Eljo");
  var range = sheet.getRange("B4:B39");
  Logger.log(range.getValues());
  var names = range.getValues();
  var namesWithIndex = names.map(function(name, index){return {"name": name[0], "index": (index + 4)}})
  return namesWithIndex;
}