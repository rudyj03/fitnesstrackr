class LeaderboardEntry {
  String name = "";
  int rank = 0;
  double score = 0.0;

  LeaderboardEntry();

  LeaderboardEntry.fromJSON(Map<String, dynamic> json) : 
        name = json['name'],
        rank = json['rank'],
        score = json['score'].toDouble();
}