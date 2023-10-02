class UserData {
  bool? success;
  Data? data;

  UserData({this.success, this.data});

  UserData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? fullName;
  String? countryId;
  String? email;
  dynamic emailVerifiedAt;
  String? phoneNumber;
  String? txnPassword;
  String? dob;
  String? gender;
  dynamic image;
  List<String>? photos;
  String? industryId;
  String? role;
  String? provider;
  String? authId;
  String? fcmToken;
  dynamic about;
  String? status;
  dynamic fcmUid;
  String? token;
  String? channelName;
  String? userId;
  String? walletCreditAmount;
  String? createdAt;
  String? updatedAt;
  String? earnWalletCredit;
  String? inviteCode;
  dynamic refferedCode;
  String? banStatus;
  dynamic otp;
  String? countryName;
  int? photoCount;
  int? followCount;
  String? profileImage;
  List<Intrest>? intrest;
  String? instagramUrl;
  String? facebookUrl;
  String? termsPageLink;
  String? privacyPageLink;
  String? videoCallCoin;
  String? audioCallCoin;
  String? rechargeCoin;
  String? redeemedCoin;

  Data({
    this.id,
    this.fullName,
    this.countryId,
    this.email,
    this.emailVerifiedAt,
    this.phoneNumber,
    this.txnPassword,
    this.dob,
    this.gender,
    this.image,
    this.photos,
    this.industryId,
    this.role,
    this.provider,
    this.authId,
    this.fcmToken,
    this.about,
    this.status,
    this.fcmUid,
    this.token,
    this.channelName,
    this.userId,
    this.walletCreditAmount,
    this.createdAt,
    this.updatedAt,
    this.earnWalletCredit,
    this.inviteCode,
    this.refferedCode,
    this.banStatus,
    this.otp,
    this.countryName,
    this.photoCount,
    this.followCount,
    this.profileImage,
    this.intrest,
    this.instagramUrl,
    this.facebookUrl,
    this.privacyPageLink,
    this.termsPageLink,
    this.videoCallCoin,
    this.audioCallCoin,
    this.rechargeCoin,
    this.redeemedCoin,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    countryId = json['country_id'].toString();
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    phoneNumber = json['phone_number'];
    txnPassword = json['txn_password'];
    dob = json['dob'];
    gender = json['gender'];
    image = json['image'];
    photos = json['photos'].cast<String>();
    industryId = json['industry_id'];
    role = json['role'];
    provider = json['provider'];
    authId = json['auth_id'];
    fcmToken = json['fcm_token'];
    about = json['about'] ?? '-';
    status = json['status'].toString();
    fcmUid = json['fcm_uid'];
    token = json['token'];
    channelName = json['channel_name'];
    userId = json['user_id'].toString();
    walletCreditAmount = json['wallet_credit_amount'].toString().split('.')[0];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    earnWalletCredit = json['earn_wallet_credit'].toString().split('.')[0];
    inviteCode = json['invite_code'];
    refferedCode = json['reffered_code'];
    banStatus = json['ban_status'].toString();
    otp = json['otp'];
    countryName = json['country_name'];
    photoCount = json['photo_count'];
    followCount = json['follow_count'];
    profileImage = json['profile_image'];
    if (json['intrest'] != dynamic) {
      intrest = <Intrest>[];
      json['intrest'].forEach((v) {
        intrest!.add(Intrest.fromJson(v));
      });
    }
    instagramUrl = json['instagram_url'];
    facebookUrl = json['facebook_url'];
    privacyPageLink = json['privacy_page_link'];
    termsPageLink = json['terms_page_link'];
    videoCallCoin = json['video_call_coin'].toString().split('.')[0];
    audioCallCoin = json['audio_call_coin'].toString().split('.')[0];
    rechargeCoin = json['recharge_coin'];
    redeemedCoin = json['redeemed_coin'];
  }
}

class Intrest {
  int? id;
  String? name;
  String? iconUrl;

  Intrest({this.id, this.name, this.iconUrl});

  Intrest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iconUrl = json['icon_url'];
  }
}

class FbUserData {
  String? _profileUrl;
  String? _listenerTopic;
  String? _role;
  String? _wallet;
  bool? _onCall;
  String? _earnWallet;
  String? _phone;
  String? _interest;
  String? _availableFor;
  String? _deviceToken;
  String? _fcmToken;
  String? _name;
  bool? _online;
  String? _id;
  String? _age;
  List<dynamic>? _blockedByMe;

  FbUserData(
      {String? profileUrl,
      String? listenerTopic,
      String? role,
      String? wallet,
      bool? onCall,
      String? earnWallet,
      String? phone,
      String? interest,
      String? availableFor,
      String? deviceToken,
      String? fcmToken,
      String? name,
      bool? online,
      String? id,
      String? age,
      List<dynamic>? blockedByMe}) {
    if (profileUrl != null) {
      _profileUrl = profileUrl;
    }
    if (listenerTopic != null) {
      _listenerTopic = listenerTopic;
    }
    if (role != null) {
      _role = role;
    }
    if (wallet != null) {
      _wallet = wallet;
    }
    if (onCall != null) {
      _onCall = onCall;
    }
    if (earnWallet != null) {
      _earnWallet = earnWallet;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (interest != null) {
      _interest = interest;
    }
    if (availableFor != null) {
      _availableFor = availableFor;
    }
    if (deviceToken != null) {
      _deviceToken = deviceToken;
    }
    if (fcmToken != null) {
      _fcmToken = fcmToken;
    }
    if (name != null) {
      _name = name;
    }
    if (online != null) {
      _online = online;
    }
    if (id != null) {
      _id = id;
    }
    if (age != null) {
      _age = age;
    }
    if (blockedByMe != null) {
      _blockedByMe = blockedByMe;
    }
  }

  String? get profileUrl => _profileUrl;
  set profileUrl(String? profileUrl) => _profileUrl = profileUrl;
  String? get listenerTopic => _listenerTopic;
  set listenerTopic(String? listenerTopic) => _listenerTopic = listenerTopic;
  String? get role => _role;
  set role(String? role) => _role = role;
  String? get wallet => _wallet;
  set wallet(String? wallet) => _wallet = wallet;
  bool? get onCall => _onCall;
  set onCall(bool? onCall) => _onCall = onCall;
  String? get earnWallet => _earnWallet;
  set earnWallet(String? earnWallet) => _earnWallet = earnWallet;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get interest => _interest;
  set interest(String? interest) => _interest = interest;
  String? get availableFor => _availableFor;
  set availableFor(String? availableFor) => _availableFor = availableFor;
  String? get deviceToken => _deviceToken;
  set deviceToken(String? deviceToken) => _deviceToken = deviceToken;
  String? get fcmToken => _fcmToken;
  set fcmToken(String? fcmToken) => _fcmToken = fcmToken;
  String? get name => _name;
  set name(String? name) => _name = name;
  bool? get online => _online;
  set online(bool? online) => _online = online;
  String? get id => _id;
  set id(String? id) => _id = id;
  String? get age => _age;
  set age(String? age) => _age = age;
  List<dynamic>? get blockedByMe => _blockedByMe;
  set blockedByMe(List<dynamic>? blockedByMe) => _blockedByMe = blockedByMe;

  FbUserData.fromJson(Map<String, dynamic> json) {
    _profileUrl = json['profileUrl'];
    _listenerTopic = json['listenerTopic'];
    _role = json['role'];
    _wallet = json['wallet'].toString().split('.')[0];
    _onCall = json['on_call'];
    _earnWallet = json['earn_wallet'].toString().split('.')[0];
    _phone = json['phone'];
    _interest = json['interest'];
    _availableFor = json['availableFor'];
    _deviceToken = json['device_token'];
    _fcmToken = json['fcm_token'];
    _name = json['name'];
    _online = json['online'];
    _id = json['id'];
    _age = json['age'];
    _blockedByMe = json['blockedByMe'];
  }

  List<int> get listInterst =>
      interest!.split(",").toList().map((e) => int.parse(e)).toList();
}
