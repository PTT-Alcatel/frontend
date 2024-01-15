import 'package:flutter/material.dart';
import 'package:pushtotalk/classes/bubble.dart';
import 'package:pushtotalk/classes/rainbow_user.dart';
import 'package:pushtotalk/components/base_scaffold.dart';
import 'package:pushtotalk/components/bubble_card.dart';
import 'package:pushtotalk/repository/api_repository.dart';
import 'package:pushtotalk/repository/platform_repository.dart';
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
  PlatformRepository platformRepository = PlatformRepository();
  ApiRepository apiRepository = ApiRepository();
  List<Bubble> bubbles = [];
  List<BubbleCard> bubbleCardList = [];
  @override
  void initState() {
    // print position
    locator.getCurrentLocation().then((value) => print(value));
    bluetoothImpl.startScan();
    fetchBubbles();
    super.initState();
  }

  void fetchBubbles() async {
    var rbBubbles = await platformRepository.getRainbowBubbles();
    List<Bubble> rainbowBubbles =
        rbBubbles.map((element) => Bubble.fromMap(element)).toList();
    List<Bubble> backBubbles = await apiRepository.getBubbles();
    var filteredRainbowBubbles = rainbowBubbles
        .where((rb) => backBubbles.any((bb) => bb.id == rb.id))
        .toList();
    for (var filteredBubble in filteredRainbowBubbles) {
      bool alreadyExists =
          bubbles.any((bubble) => bubble.id == filteredBubble.id);
      if (!alreadyExists) {
        setState(() {
          bubbles.add(filteredBubble);
        });
      }
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
        },
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: bubbles.length,
            itemBuilder: (context, index) {
              return BubbleCard(
                bubble: bubbles[index],
              );
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
                      bubbles.add(newBubble.bubble);
                    });
                  },
                );
              });
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
