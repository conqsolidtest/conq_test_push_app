class InformationDto {
  String title;
  String body;
  String imageUrl;
  
  InformationDto({this.title, this.body});

  InformationDto.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }
}
