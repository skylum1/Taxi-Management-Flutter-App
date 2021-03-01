class Taxi {
  int _id;
  int _driverId;
  String _license;
  String _model;
  int _carCondition;
  int _available;
  Taxi(this._driverId, this._model, this._carCondition, this._license,
      this._available);

  // Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get id => _id;

  int get driverId => _driverId;

  String get license => _license;

  int get carCondition => _carCondition;

  int get available => _available;

  String get model => _model;

  set driverId(int newTitle) {
    this._driverId = newTitle;
  }

  set available(int newTitle) {
    this._available = newTitle;
  }

  set license(String newDescription) {
    if (newDescription.length <= 25) {
      this._license = newDescription;
    }
  }

  set carCondition(int newPriority) {
    if (newPriority >= 0 && newPriority < 11) this._carCondition = newPriority;
  }

  set model(String newDate) {
    this._model = newDate;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['driverId'] = _driverId;
    map['license'] = _license;
    map['carCondition'] = _carCondition;
    map['model'] = _model;
    map['available'] = _available;
    return map;
  }

  // Extract a Note object from a Map object
  Taxi.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._driverId = map['driverId'];
    this._license = map['license'];
    this._carCondition = map['carCondition'];
    this._available = map['available'];
    this._model = map['model'];
  }
}
