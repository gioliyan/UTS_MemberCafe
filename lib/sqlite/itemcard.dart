class ItemCard {
  int _id;
  String _name;
  String _code;
  int get id => this._id;

  set id(int value) => this._id = value;

  get name => this._name;

  set name(value) => this._name = value;

  get code => this._code;

  set code(value) => this._code = value;

  ItemCard(this._name, this._code);

  //konstruktor konversi dari map ke item
  ItemCard.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._code = map['code'];
  }

  //konversi dari item ke map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['code'] = code;
    return map;
  }
}
