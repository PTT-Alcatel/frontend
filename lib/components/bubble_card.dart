import 'package:flutter/material.dart';
import 'package:pushtotalk/components/bubble_modification_forrm.dart';
import 'package:pushtotalk/pages/voice_page.dart';
import 'package:pushtotalk/classes/bubble.dart';

class BubbleCard extends StatefulWidget {
  final Bubble bubble;

  const BubbleCard({super.key, required this.bubble});

  @override
  State<BubbleCard> createState() => _BubbleCardState();
}

class _BubbleCardState extends State<BubbleCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: _showBubbleModificationForm,
        child: Card(
          child: ListTile(
            title: Text(widget.bubble.name),
            subtitle: Text(widget.bubble.topic ?? ''),
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
          onBubbleModified: (modifiedBubble) {
            print('Modified Bubble: $modifiedBubble');
          },
          onBubbleUpdated: (Bubble) {},
          onBubbleDeleted: (Bubble) {},
        );
      },
    );
  }
}
