class Note {
  int _id;
  int _taxiId;
  String _destination;
  String _source;
  int _clientId;
  String _date;
  int _amount;

  Note(this._taxiId, this._date, this._amount, this._destination,
      this._clientId, this._source);

  // Note.withId(this._id, this._title, this._date, this._priority, [this._description]);

  int get id => _id;

  int get taxiId => _taxiId;

  int get clientId => _clientId;

  String get destination => _destination;

  String get source => _source;

  int get amount => _amount;

  String get date => _date;

  set taxiId(int newTitle) {
    this._taxiId = newTitle;
  }

  set clientId(int newTitle) {
    this._clientId = newTitle;
  }

  set destination(String newDescription) {
    if (newDescription.length <= 255) {
      this._destination = newDescription;
    }
  }

  set source(String newDescription) {
    if (newDescription.length <= 255) {
      this._source = newDescription;
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
    map['taxiId'] = _taxiId;
    map['destination'] = _destination;
    map['amount'] = _amount;
    map['date'] = _date;
    map['source'] = _source;
    map['clientId'] = _clientId;

    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._taxiId = map['taxiId'];
    this._destination = map['destination'];
    this._amount = map['amount'];
    this._date = map['date'];
    this._source = map['source'];
    this._clientId = map['clientId'];
  }
}
