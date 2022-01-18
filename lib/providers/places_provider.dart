import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/place.dart';

import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place getById(String id) {
    return _items.firstWhere((place) => id == place.id);
  }

  Future<void> addPlace(
      String title, File takenPicture, PlaceLocation savedLocation) async {
    final locationAddress = await LocationHelper.getPlaceAddress(
      latitude: savedLocation.latitude,
      longitude: savedLocation.longitude,
    );
    final locationWithAddress = PlaceLocation(
        latitude: savedLocation.latitude,
        longitude: savedLocation.longitude,
        address: locationAddress);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: locationWithAddress,
        picture: takenPicture);
    _items.insert(0, newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'picturePath': newPlace.picture.path,
      'latitude': newPlace.location!.latitude,
      'longitude': newPlace.location!.longitude,
      'address': newPlace.location!.address!,
    });
  }

  Future<void> deletePlace(String placeId) async {
    _items.removeWhere((item) => item.id == placeId);
    notifyListeners();
    await DBHelper.delete('user_places', placeId);
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (place) => Place(
            id: place['id'],
            title: place['title'],
            picture: File(place['picturePath']),
            location: PlaceLocation(
              latitude: place['latitude'],
              longitude: place['longitude'],
              address: place['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
