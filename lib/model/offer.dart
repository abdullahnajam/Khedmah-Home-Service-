class Offer{
  String id,title,subtitle,image,category;

  Offer(this.id, this.title, this.subtitle, this.image, this.category);

  Offer.fromJson(var value){
    this.title=value['title'];
    this.subtitle=value['subtitle'];
    this.image=value['image'];
    this.category=value['category'];
  }
}