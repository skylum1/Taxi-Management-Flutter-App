class Note {
  int _id;
  int _driverId;
  String _description;
  String _date;
  int _amount;

  Note(this._driverId, this._date, this._amount, this._description);

  // Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get id => _id;

  int get driverId => _driverId;

  String get description => _description;

  int get amount => _amount;

  String get date => _date;

  set driverId(int newTitle) {
    this._driverId = newTitle;
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set amount(int newPriority) {
    this._amount = newPriority;
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['driverId'] = _driverId;
    map['description'] = _description;
    map['amount'] = _amount;
    map['date'] = _date;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._driverId = map['driverId'];
    this._description = map['description'];
    this._amount = map['amount'];
    this._date = map['date'];
  }
}
