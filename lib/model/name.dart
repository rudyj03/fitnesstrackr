class Name {
  String name = "";
  int index = 0;

  Name();

  Name.fromJSON(Map<String, dynamic> json) : 
        name = json['name'],
        index = json['index'];
}