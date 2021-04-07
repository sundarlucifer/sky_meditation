import 'package:flutter/material.dart';
import 'package:sky_meditation/data/data.dart';
import 'package:sky_meditation/screens/screens.dart';
import 'package:sky_meditation/utils/utils.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: ListView(
        children: [
          MeditationCard(
            title: 'Thuriyatheetham Meditation',
            image: 'assets/universe.jpg',
            onTap: () {
              meditationHolderUtil.meditation = Meditations().thuriyam;
              Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => TweakPage()));
            }
          ),
        ],
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

  /// The operation to perform when the user taps the card
  ///
  /// Example: Route to another screen
  final Function onTap;

  const MeditationCard({
    Key key,
    @required this.title,
    @required this.image,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Color.fromRGBO(241, 209, 102, 0.25),
          child: Row(
            children: [
              ClipRect(child: Image.asset(image, height:100, width: 100, fit: BoxFit.cover,)),
              SizedBox(width: 8),
              Expanded(
                  child: Text(
                title,
                style: TextStyle(fontSize: 18),
                overflow: TextOverflow.clip,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
