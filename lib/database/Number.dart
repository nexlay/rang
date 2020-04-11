class Number {
  // DB fields
  int id;
  String content;
  int title;


  // Constructor
  Number({this.id, this.content, this.title});

  // Get methods
  int get _id => id;
  String get _content => content;

  int get _title => title;


  // Set methods
  set _content(String newContent) {
    this.content = newContent;
  }


  set _title(int newTitle) {
    this.title = newTitle;
  }


//Convert our object into Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null){
      map['id'] = id;}
    map['title'] = title;
    map['content'] = content;

    return map;
  }
  Number.fromMapObject(Map<String, dynamic>map){
    this.id = map['id'];
    this.title = map['title'];
    this.content = map['content'];

  }
  Number.fromJson(Map<String, dynamic>json)
      :content = json['text'];

}
