class BookingModel{
  String id,description,location,time,status,date;
  int price;
  List<dynamic> imgUrl;

  BookingModel(this.id, this.description, this.location, this.price, this.time,
      this.status, this.imgUrl,this.date);
}