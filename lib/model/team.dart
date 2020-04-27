class Team {
  String teamName = "";
  List<String> members = List<String>();

  Team();

  Team.fromJSON(Map<String, dynamic> json) : 
        teamName = json['teamName'],
        members = List.from(json['members']);
}