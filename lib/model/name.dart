class Name {
  String name;
  int index;

  Name();

  Name.fromJSON(Map<String, dynamic> json) : 
        name = json['name'],
        index = json['index'];
}