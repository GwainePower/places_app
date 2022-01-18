import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/location_helper.dart';

import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput(this.selectPosition, {Key? key}) : super(key: key);

  final Function selectPosition;

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  Future<void> _getCurrentLocation() async {
    final locationData = await Location().getLocation();
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImageUrl(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );
    setState(() => _previewImageUrl = staticMapImageUrl);
    widget.selectPosition(
      locationData.latitude,
      locationData.longitude,
    );
  }

  // Там в push в <> скобках LatLng - это значит, что прога будет ждать
  // именно этот тип переменной при открытии карты
  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImageUrl(
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
    );
    setState(() => _previewImageUrl = staticMapImageUrl);
    widget.selectPosition(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: _previewImageUrl == null
              ? const Text(
                  'Локация не выбрана',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () => _getCurrentLocation(),
              icon: const Icon(Icons.location_on),
              label: const Text('Ваша локация'),
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
            ),
            TextButton.icon(
              onPressed: () => _selectOnMap(),
              icon: const Icon(Icons.map),
              label: const Text('Выбрать на карте'),
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
            ),
          ],
        )
      ],
    );
  }
}
