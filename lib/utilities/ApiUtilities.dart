import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:conq_test_push_app/dto/information_dto.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://us-central1-conq-test-api.cloudfunctions.net/";

class ApiUtilities {
  static List<String> images = [
    "021-leaf.png",
    "036-rain.png",
    "032-tree.png",
    "005-fish.png",
    "023-carrot.png",
    "024-grass.png",
    "034-earth.png"
  ];

  static Future<List<InformationDto>> getInformations() async {
    print('getInformation');
    //var response = (await http.get(baseUrl + "/informations")).body;
    List<InformationDto> informations = new List();
    InformationDto informationDto;
    Random rnd = Random();
    for (var i = 0; i < 100; i++) {
      informationDto = InformationDto(body: i.toString(), title: i.toString());
      informationDto.imageUrl = images[rnd.nextInt(images.length)];
      informations.add(informationDto);
    }

    return informations;
  }
}
