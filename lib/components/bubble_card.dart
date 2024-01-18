import 'package:flutter/material.dart';
import 'package:pushtotalk/components/bubble_modification_forrm.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pushtotalk/pages/voice_page.dart';
import 'package:pushtotalk/classes/bubble.dart';

class BubbleCard extends StatefulWidget {
  final Bubble bubble;
  final Position myPosition;

  const BubbleCard({Key? key, required this.bubble, required this.myPosition})
      : super(key: key);

  @override
  State<BubbleCard> createState() => _BubbleCardState();
}

class _BubbleCardState extends State<BubbleCard> {
  double distance = 0.0;

  @override
  void initState() {
    super.initState();
    calculateDistance();
  }

  void calculateDistance() {
    double distanceInMeters = Geolocator.distanceBetween(
      widget.myPosition.latitude,
      widget.myPosition.longitude,
      widget.bubble.latitude,
      widget.bubble.longitude,
    );
    setState(() {
      distance = distanceInMeters; // Distance en mètres
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: _showBubbleModificationForm,
        child: Card(
          child: ListTile(
            title: Text(widget.bubble.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.bubble.topic ?? ''),
                Text(
                  '${distance.toStringAsFixed(2)} m de vous',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey), // Ajout de style
                ),
              ],
            ),
            leading: const Icon(Icons.person),
            iconColor: Colors.black,
            textColor: Colors.black,
            trailing: GestureDetector(
              child: const Icon(Icons.meeting_room_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoicePage(bubble: widget.bubble.name),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showBubbleModificationForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BubbleModificationForm(
          bubble: widget.bubble,
          onBubbleUpdated: (Bubble bubble) {
            print('Updated Bubble: ${bubble.name}');
          },
          onBubbleDeleted: (Bubble bubble) {
            print('Deleted Bubble: ${bubble.id}');
          },
        );
      },
    );
  }
}
