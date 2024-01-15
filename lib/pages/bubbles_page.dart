import 'package:flutter/material.dart';
import 'package:pushtotalk/classes/bubble.dart';
import 'package:pushtotalk/classes/rainbow_user.dart';
import 'package:pushtotalk/components/base_scaffold.dart';
import 'package:pushtotalk/components/bubble_card.dart';
import 'package:pushtotalk/repository/api_repository.dart';
import 'package:pushtotalk/services/bluetooth_impl.dart';
import 'package:pushtotalk/components/bubble_creation_form.dart';
import 'package:pushtotalk/services/locator_impl.dart';
import 'package:pushtotalk/pages/profile_page.dart';

class BubblesPage extends StatefulWidget {
  final RainbowUser user;
  const BubblesPage({Key? key, required this.user}) : super(key: key);

  @override
  State<BubblesPage> createState() => _BubblesPageState();
}

class _BubblesPageState extends State<BubblesPage> {
  LocatorImp locator = LocatorImp();
  BluetoothImpl bluetoothImpl = BluetoothImpl();
  List<BubbleCard> bubbleList = [];
  ApiRepository apiRepository = ApiRepository();
  @override
  void initState() {
    // print position
    locator.getCurrentLocation().then((value) => print(value));
    bluetoothImpl.startScan();
    super.initState();
    fetchBubbles();
  }

  void fetchBubbles() async {
    try {
      List<BubbleBack> bubbles = await apiRepository.getBubbles();
      print(bubbles);
      List<Bubble> bubblefinalList = bubbles
          .map((bubble) => Bubble(
                bubble_GUID: bubble.bubble_GUID,
                name: bubble.name,
                topic: bubble.topic,
                latitude: bubble.latitude,
                longitude: bubble.longitude,
                creatorId: bubble.creatorId,
              ))
          .toList();
      setState(() {
        bubbleList = bubblefinalList
            .map((bubble) => BubbleCard(bubble: bubble))
            .toList();
      });
    } catch (e) {
      // Gérer l'exception ou l'erreur
      print("Erreur lors de la récupération des bulles: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(user: widget.user),
              ),
            );
          },
          icon: const Icon(Icons.person),
        ),
      ],
      title: 'Liste des canaux',
      body: RefreshIndicator(
        onRefresh: () async {
          locator.getCurrentLocation().then((value) => print(value));
          bluetoothImpl.startScan();
          fetchBubbles();
          await Future.delayed(const Duration(seconds: 2));
        },
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: bubbleList.length,
            itemBuilder: (context, index) {
              return bubbleList[index];
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return BubbleCreationForm(
                    onBubbleCreated: (BubbleCard newBubble) {
                  setState(() {
                    bubbleList.add(newBubble);
                  });
                });
              });
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
