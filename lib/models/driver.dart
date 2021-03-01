class Driver {
  int _id;
  String _name;
  String _phone;
  String _address;
  Driver(this._name, this._phone, this._address);
  // Driver.withId(this._id, this._name, this._phone, this._address);
  int get id => _id;
  String get name => _name;
  String get phone => _phone;
  String get address => _address;

  set name(String newTitle) {
    if (newTitle.length <= 50) {
      this._name = newTitle;
    }
  }

  set phone(String newDescription) {
    if (newDescription.length <= 12) {
      this._phone = newDescription;
    }
  }

  set address(String newPriority) {
    if (newPriority.length <= 150) {
      this._address = newPriority;
    }
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['phone'] = _phone;
    map['address'] = _address;
    return map;
  }

  Driver.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._address = map['address'];
    this._phone = map['phone'];
  }
}
