class UserData{
  String id,name,email,gender,phoneCode,phoneNumber,surname,countryCode;

  UserData(this.id, this.name, this.email, this.gender, this.phoneCode,
      this.phoneNumber, this.surname,this.countryCode);

  UserData.fromJson(var value){
    this.name=value['name'];
    this.email=value['email'];
    this.gender=value['gender'];
    this.phoneCode=value['phoneCode'];
    this.phoneNumber=value['phoneNumber'];
    this.surname=value['surname'];
    this.countryCode=value['countryCode'];
  }
}