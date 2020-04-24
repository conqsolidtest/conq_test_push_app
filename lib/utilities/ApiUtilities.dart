import 'dart:async';
import 'dart:convert';
import 'package:conq_test_push_app/dto/information_dto.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://us-central1-conq-test-api.cloudfunctions.net/";

class ApiUtilities {
  static Future<List<InformationDto>> getInformations() async {
    print('getInformation');
    var response = (await http.get(baseUrl + "/informations")).body;
    List<InformationDto> informations = new List();

    if (response.isNotEmpty) {
      final jsonResponse = json.decode(response);

      var informationDto;
      if (jsonResponse != null) {
        for (var i = 0; i < 5; i++) {
          jsonResponse.forEach((inf) {
            informationDto = InformationDto.fromJson(inf);
            informations.add(informationDto);
          });
        }
      }
    }

    return informations;
  }
}
