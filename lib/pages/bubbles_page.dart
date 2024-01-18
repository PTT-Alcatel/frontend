import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  // BluetoothImpl bluetoothImpl = BluetoothImpl();
  PlatformRepository platformRepository = PlatformRepository();
  ApiRepository apiRepository = ApiRepository();
  List<Bubble> bubbles = [];
  List<BubbleCard> bubbleCardList = [];
  @override
  void initState() {
    // print position
    locator.getCurrentLocation().then((value) => print(value));
    // bluetoothImpl.startScan();
    fetchBubbles();
    checkNearlyBubbles();
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
        Bubble matchingBackBubble = backBubbles
            .firstWhere((backBubble) => backBubble.id == filteredBubble.id);

        filteredBubble.latitude = matchingBackBubble.latitude;
        filteredBubble.longitude = matchingBackBubble.longitude;

        setState(() {
          bubbles.add(filteredBubble);
        });
      }
    }
  }

  void checkNearlyBubbles() async {
    Position myPosition = await locator.getCurrentLocation();
    List<Bubble> nearbyBubbles = [];

    for (var bubble in bubbles) {
      bool isNear5m = await locator.isLocationNearFromMe(
          myPosition: myPosition,
          otherPosition: Position(
            latitude: bubble.latitude,
            longitude: bubble.longitude,
            timestamp: DateTime(0),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          ),
          distance: 5);
      print('my position $myPosition.latitude, $myPosition.longitude');
      print('bubble position ${bubble.latitude}, ${bubble.longitude}');
      print('isNear5m $isNear5m');
      if (isNear5m) {
        nearbyBubbles.add(bubble);
      }
      setState(() {
        bubbles = nearbyBubbles;
      });
    }
  }

  void refreshBubblesLocation() {
    fetchBubbles();
    checkNearlyBubbles();
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
          // bluetoothImpl.startScan();
          refreshBubblesLocation();
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
