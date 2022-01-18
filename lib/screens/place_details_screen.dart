import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';

import '../providers/places_provider.dart';

import '../screens/map_screen.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/place-details';

  @override
  Widget build(BuildContext context) {
    final placeId = ModalRoute.of(context)!.settings.arguments as String;
    // Не забываем ставить listen: false
    final place =
        Provider.of<PlacesProvider>(context, listen: false).getById(placeId);
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Hero(
              tag: placeId,
              child: Image.file(
                place.picture,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            place.location!.address!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => MapScreen(
                  isSelecting: false,
                  initialLocation: PlaceLocation(
                    latitude: place.location!.latitude,
                    longitude: place.location!.longitude,
                  ),
                ),
              ),
            ),
            icon: const Icon(Icons.map),
            label: const Text('Показать на карте'),
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          )
        ],
      ),
    );
  }
}
