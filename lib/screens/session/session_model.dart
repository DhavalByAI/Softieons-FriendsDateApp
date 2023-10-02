class SessionModel {
  bool? _success;
  List<Data>? _data;

  SessionModel({bool? success, List<Data>? data}) {
    if (success != null) {
      _success = success;
    }
    if (data != null) {
      _data = data;
    }
  }

  bool? get success => _success;
  set success(bool? success) => _success = success;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;

  SessionModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = _success;
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? _userId;
  String? _totalCredit;
  String? _totalMinutes;
  String? _callingDate;
  String? _type;
  String? _fullName;
  String? _role;
  String? _uniqueCall;
  String? _countryName;
  String? _imageurl;

  Data(
      {String? userId,
      String? totalCredit,
      String? totalMinutes,
      String? callingDate,
      String? type,
      String? fullName,
      String? role,
      String? uniqueCall,
      String? countryName,
      String? imageurl}) {
    if (userId != null) {
      _userId = userId;
    }
    if (totalCredit != null) {
      _totalCredit = totalCredit;
    }
    if (totalMinutes != null) {
      _totalMinutes = totalMinutes;
    }
    if (callingDate != null) {
      _callingDate = callingDate;
    }
    if (type != null) {
      _type = type;
    }
    if (fullName != null) {
      _fullName = fullName;
    }
    if (role != null) {
      _role = role;
    }
    if (uniqueCall != null) {
      _uniqueCall = uniqueCall;
    }
    if (countryName != null) {
      _countryName = countryName;
    }
    if (imageurl != null) {
      _imageurl = imageurl;
    }
  }

  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get totalCredit => _totalCredit;
  set totalCredit(String? totalCredit) => _totalCredit = totalCredit;
  String? get totalMinutes => _totalMinutes;
  set totalMinutes(String? totalMinutes) => _totalMinutes = totalMinutes;
  String? get callingDate => _callingDate;
  set callingDate(String? callingDate) => _callingDate = callingDate;
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get fullName => _fullName;
  set fullName(String? fullName) => _fullName = fullName;
  String? get role => _role;
  set role(String? role) => _role = role;
  String? get uniqueCall => _uniqueCall;
  set uniqueCall(String? uniqueCall) => _uniqueCall = uniqueCall;
  String? get countryName => _countryName;
  set countryName(String? countryName) => _countryName = countryName;
  String? get imageurl => _imageurl;
  set imageurl(String? imageurl) => _imageurl = imageurl;

  Data.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _totalCredit = json['total_credit'];
    _totalMinutes = json['total_minutes'];
    _callingDate = json['calling_date'];
    _type = json['type'];
    _fullName = json['full_name'];
    _role = json['role'];
    _uniqueCall = json['unique_call'];
    _countryName = json['country_name'];
    _imageurl = json['imageurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = _userId;
    data['total_credit'] = _totalCredit;
    data['total_minutes'] = _totalMinutes;
    data['calling_date'] = _callingDate;
    data['type'] = _type;
    data['full_name'] = _fullName;
    data['role'] = _role;
    data['unique_call'] = _uniqueCall;
    data['country_name'] = _countryName;
    data['imageurl'] = _imageurl;
    return data;
  }
}
