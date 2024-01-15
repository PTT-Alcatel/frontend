import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pushtotalk/classes/bubble.dart';
import 'package:pushtotalk/components/bubble_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pushtotalk/interfaces/locator.dart';
import 'package:pushtotalk/repository/platform_repository.dart';
import 'package:pushtotalk/services/locator_impl.dart';
import 'package:pushtotalk/components/bubble_form_field.dart';
import 'package:pushtotalk/interfaces/api.dart';
import 'package:pushtotalk/repository/api_repository.dart';

class BubbleCreationForm extends StatefulWidget {
  final Function(BubbleCard) onBubbleCreated;

  const BubbleCreationForm({Key? key, required this.onBubbleCreated})
      : super(key: key);

  @override
  State<BubbleCreationForm> createState() => _BubbleCreationFormState();
}

class _BubbleCreationFormState extends State<BubbleCreationForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  Locator locator = LocatorImp();
  Api apiRepository = ApiRepository();
  PlatformRepository platformRepository = PlatformRepository();

  String longitude = '';
  String latitude = '';

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Création de la bulle',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    BubbleFormField(
                      title: 'Nom',
                      icon: Icons.title,
                      hint: 'Ex: nom super cool',
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BubbleFormField(
                      title: 'Description',
                      icon: Icons.description,
                      hint: 'Ex: description tip top',
                      controller: topicController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Long: $longitude',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Lat: $latitude',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton.icon(
                          onPressed: () async {
                            Position position =
                                await locator.getCurrentLocation();
                            setState(() {
                              longitude = position.longitude.toString();
                              latitude = position.latitude.toString();
                            });
                          },
                          label: const Text('Actualiser'),
                          icon: const Icon(Icons.location_on),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (formKey.currentState!.validate()) {
                            createBubbleAndNavigate(context);
                            Navigator.pop(context);
                          }
                        });
                        nameController.clear();
                        topicController.clear();
                      },
                      label: const Text('Valider'),
                      icon: const Icon(Icons.check),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> createBubbleAndNavigate(BuildContext context) async {
    String name = nameController.text;
    String topic = topicController.text;

    try {
      Bubble bubble = await platformRepository.createBubble(name, topic);
      bubble.latitude = double.parse(latitude);
      bubble.longitude = double.parse(longitude);

      http.Response response = await apiRepository.createBubble(bubble);
      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        widget.onBubbleCreated(BubbleCard(bubble: bubble));
      }
    } catch (error) {
      print("Error creating bubble: $error");
    }
  }
}
