import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {Key? key,
      this.initialLocation =
          const PlaceLocation(latitude: 55.753120, longitude: 37.622224),
      this.isSelecting = false})
      : super(key: key);

  final PlaceLocation initialLocation;
  final bool isSelecting;

// Если хочешь брать переменные из класса что выше, всегда прописывай их
// через widget. в Stateful виджетах!
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectLocation(LatLng position) {
    setState(() => _pickedPosition = position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карты ебать'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: _pickedPosition == null
                  ? null
                  : () => Navigator.of(context).pop(_pickedPosition),
              icon: const Icon(Icons.check),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        // Сам по себе onTap возвращает LatLng координаты!
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedPosition == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedPosition ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                )
              },
      ),
    );
  }
}
