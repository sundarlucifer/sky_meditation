import 'package:flutter/material.dart';
import 'package:sky_meditation/data/data.dart';
import 'package:sky_meditation/screens/screens.dart';
import 'package:sky_meditation/utils/utils.dart';

class HomePage extends StatelessWidget {
  static const TAG = 'home-page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: MyDrawer(),
      body: ListView(
        children: Meditations()
            .meditationMap
            .entries
            .map<Widget>((entry) => MeditationCard(
                title: entry.value.title,
                image: 'assets/universe.jpg',
                duration: entry.value.duration,
                onTap: () {
                  meditationHolderUtil.meditation =
                      Meditations().meditationMap[entry.key];
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => TweakPage()));
                }))
            .toList(),
      ),
    );
  }
}

class MeditationCard extends StatelessWidget {
  /// The title of the meditation, to display in the card
  ///
  /// Example: 'Agna Meditation'
  final String title;

  /// The path to the image in the assets
  ///
  /// Example: 'assets/images/sample.png'
  final String image;

  final String duration;

  /// The operation to perform when the user taps the card
  ///
  /// Example: Route to another screen
  final Function onTap;

  const MeditationCard({
    Key key,
    @required this.title,
    @required this.image,
    @required this.duration,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.green[50],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  image,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                  child: Text(
                title,
                style: TextStyle(fontSize: 18),
                overflow: TextOverflow.clip,
              )),
              SizedBox(width: 4),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(duration),
                  SizedBox(height: 12),
                ],
              ),
              SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }
}
