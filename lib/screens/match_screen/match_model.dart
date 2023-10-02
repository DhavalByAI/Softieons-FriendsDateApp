class MatchModel {
  bool? _success;
  List<Data>? _data;

  MatchModel({bool? success, List<Data>? data}) {
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

  MatchModel.fromJson(Map<String, dynamic> json) {
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
  int? _id;
  String? _name;
  List<UserList>? _userList;

  Data({int? id, String? name, List<UserList>? userList}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (userList != null) {
      _userList = userList;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  List<UserList>? get userList => _userList;
  set userList(List<UserList>? userList) => _userList = userList;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    if (json['user_list'] != null) {
      _userList = <UserList>[];
      json['user_list'].forEach((v) {
        _userList!.add(UserList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    if (_userList != null) {
      data['user_list'] = _userList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserList {
  String? _categoryId;
  int? _id;
  String? _fullName;
  String? _dob;
  String? _image;
  String? _countryName;
  String? _status;
  int? _age;

  UserList(
      {String? categoryId,
      int? id,
      String? fullName,
      String? dob,
      String? image,
      String? countryName,
      String? status,
      int? age}) {
    if (categoryId != null) {
      _categoryId = categoryId;
    }
    if (id != null) {
      _id = id;
    }
    if (fullName != null) {
      _fullName = fullName;
    }
    if (dob != null) {
      _dob = dob;
    }
    if (image != null) {
      _image = image;
    }
    if (countryName != null) {
      _countryName = countryName;
    }
    if (status != null) {
      _status = status;
    }
    if (age != null) {
      _age = age;
    }
  }

  String? get categoryId => _categoryId;
  set categoryId(String? categoryId) => _categoryId = categoryId;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get fullName => _fullName;
  set fullName(String? fullName) => _fullName = fullName;
  String? get dob => _dob;
  set dob(String? dob) => _dob = dob;
  String? get image => _image;
  set image(String? image) => _image = image;
  String? get countryName => _countryName;
  set countryName(String? countryName) => _countryName = countryName;
  String? get status => _status;
  set status(String? status) => _status = status;
  int? get age => _age;
  set age(int? age) => _age = age;

  UserList.fromJson(Map<String, dynamic> json) {
    _categoryId = json['category_id'];
    _id = json['id'];
    _fullName = json['full_name'];
    _dob = json['dob'];
    _image = json['image'];
    _countryName = json['country_name'];
    _status = json['status'];
    _age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = _categoryId;
    data['id'] = _id;
    data['full_name'] = _fullName;
    data['dob'] = _dob;
    data['image'] = _image;
    data['country_name'] = _countryName;
    data['status'] = _status;
    data['age'] = _age;
    return data;
  }
}
