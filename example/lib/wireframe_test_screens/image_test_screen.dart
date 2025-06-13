import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WireframeImageTestScreen extends StatefulWidget {
  const WireframeImageTestScreen({Key? key}) : super(key: key);

  @override
  State<WireframeImageTestScreen> createState() => _WireframeImageTestScreenState();
}

class _WireframeImageTestScreenState extends State<WireframeImageTestScreen> {
  int _currentImageIndex = 2;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentImageIndex++;
        if (_currentImageIndex > 7) {
          _currentImageIndex = 2;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Single widget test Screen")),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: ListView(
            children: [
              SizedBox(height: 200),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/00${_currentImageIndex}.png",
                width: 100,
                height: 300,
                fit: BoxFit.cover,
              ),
              Text("Cropped Image"),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 20,
                      child: Image.asset(
                        'res/images/two_colors.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    const SizedBox(width: 100),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.4, // Only show the left 50% of the image
                    child: Image.asset(
                      'res/images/two_colors.png',
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 0.4, // Only show the left 50% of the image
                    child: Image.asset(
                      'res/images/two_colors.png',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        'res/images/Smartlook.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    SizedBox(width: 100),
                  ],
                ),
              ),
              Text("Network:"),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/002.png",
                width: 100,
                height: 300,
                fit: BoxFit.cover,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/003.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/004.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/005.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/006.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Image.network(
                "https://assets.pokemon.com/assets/cms2/img/pokedex/full/007.png",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              CachedNetworkImage(
                imageUrl: "https://picsum.photos/id/237/200/300",
                width: 100,
                height: 300,
                fit: BoxFit.fitHeight,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: BlendMode.values.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BlendModeListItem(BlendMode.values[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlendModeListItem extends StatelessWidget {
  final BlendMode blendMode;

  const BlendModeListItem(this.blendMode);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text(blendMode.toString().split('.')[1]),
          Image.asset(
            'res/images/Smartlook.png',
            color: Colors.blue.withOpacity(0.5),
            colorBlendMode: blendMode,
          ),
        ],
      ),
    );
  }
}
