import 'package:flutter/material.dart';
import 'package:pushtotalk/classes/bubble.dart';
import 'package:pushtotalk/components/bubble_form_field.dart';

class BubbleModificationForm extends StatefulWidget {
  final Bubble bubble;
  final Function(Bubble) onBubbleUpdated;
  final Function(Bubble) onBubbleDeleted;

  const BubbleModificationForm({
    Key? key,
    required this.bubble,
    required this.onBubbleUpdated,
    required this.onBubbleDeleted,
    required Null Function(dynamic modifiedBubble) onBubbleModified,
  }) : super(key: key);

  @override
  State<BubbleModificationForm> createState() => _BubbleModificationFormState();
}

class _BubbleModificationFormState extends State<BubbleModificationForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController topicController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Prefill the form fields with existing bubble data
    nameController.text = widget.bubble.name;
    topicController.text = widget.bubble.topic ?? '';
  }

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
                      'Modification de la bulle',
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              deleteBubble();
                              Navigator.pop(context);
                            });
                          },
                          label: const Text('Supprimer'),
                          icon: const Icon(Icons.delete),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              if (formKey.currentState!.validate()) {
                                updateBubble();
                                Navigator.pop(context);
                              }
                            });
                          },
                          label: const Text('Mettre à jour'),
                          icon: const Icon(Icons.update),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void updateBubble() {
    String name = nameController.text;
    String topic = topicController.text;

    // Create a new Bubble with modified data
    Bubble updatedBubble = Bubble(
      id: widget.bubble.id,
      name: name,
      topic: topic,
      latitude: widget.bubble.latitude,
      longitude: widget.bubble.longitude,
    );

    // Call the callback to notify about the updated bubble
    widget.onBubbleUpdated(updatedBubble);
  }

  void deleteBubble() {
    // Call the callback to notify about the deleted bubble
    widget.onBubbleDeleted(widget.bubble);
  }
}
