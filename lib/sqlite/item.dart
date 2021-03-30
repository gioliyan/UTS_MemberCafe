class ItemProfile {
  int _id;
  String _name;
  String _code;
  int _phone;
  String _address;

  int get id => this._id;

  set id(int value) => this._id = value;

  get name => this._name;

  set name(value) => this._name = value;

  get code => this._code;

  set code(value) => this._code = value;

  get phone => this._phone;

  set phone(value) => this._phone = value;

  get address => this._address;

  set address(value) => this._address = value;

  ItemProfile(this._name, this._code, this._phone, this._address);

  //konstruktor konversi dari map ke item
  ItemProfile.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._code = map['code'];
    this._phone = map['phone'];
    this._address = map['address'];
  }

  //konversi dari item ke map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['code'] = code;
    map['phone'] = phone;
    map['address'] = address;
    return map;
  }
}
