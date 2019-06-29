
class Account{

  int id;
  String emId;
  String nickname;
  String password;
  String email;
  String phone;
  int sex;
  String signature;
  String birthday;
  String city;
  String headPortrait;
  String cardPicture;
  int getBottleCount;
  int putBottleCount;
  int attentionCount;
  int fansCount;
  String creatDate;
  String updateDate;
  int warningCount;
  String latelyLoginDate;

 Account({this.id,this.emId,this.nickname,this.password,
   this.email,this.phone,this.sex,this.signature,this.birthday,
   this.city,this.headPortrait,this.cardPicture,this.getBottleCount,
   this.putBottleCount,this.attentionCount,this.fansCount,this.creatDate,
   this.updateDate,this.warningCount,this.latelyLoginDate});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      emId: json['emId'],
      nickname: json['nickname'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
      sex: json["sex"],
      signature: json["signature"],
      birthday: json["birthday"],
      city: json["city"],
      headPortrait: json["headPortrait"],
      cardPicture: json["cardPicture"],
      getBottleCount: json["getBottleCount"],
      putBottleCount: json["putBottleCount"],
      attentionCount: json["attentionCount"],
      fansCount: json["fansCount"],
      creatDate: json["creatDate"],
      updateDate: json["updateDate"],
      warningCount: json["warningCount"],
      latelyLoginDate: json["latelyLoginDate"]
    );
  }


}