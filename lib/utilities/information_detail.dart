import 'package:conq_test_push_app/dto/information_dto.dart';
import 'package:flutter/material.dart';

class InformationDetail extends StatelessWidget {
  final InformationDto informationDto;

  InformationDetail({this.informationDto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(this.informationDto.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            width: double.infinity,
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                this.informationDto.body
              ),
            ),
          ),
        ),
      ),
    );
  }
}
