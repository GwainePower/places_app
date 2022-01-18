import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.dart';

import '../providers/places_provider.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({Key? key}) : super(key: key);
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

final _titleControler = TextEditingController();
File? _takenPicture;
PlaceLocation? _savedPosition;

void _selectPicture(File takenPicture) {
  _takenPicture = takenPicture;
}

void _selectPosition(double latitude, double longitude) {
  _savedPosition = PlaceLocation(latitude: latitude, longitude: longitude);
}

void _savePlace(BuildContext context) {
  if (_titleControler.text.isEmpty ||
      _takenPicture == null ||
      _savedPosition == null) {
    return;
  }
  Provider.of<PlacesProvider>(context, listen: false)
      .addPlace(_titleControler.text, _takenPicture!, _savedPosition!);
  Navigator.of(context).pop();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  // @override
  // void dispose() {
  //   _titleControler.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить новое место'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration:
                          const InputDecoration(labelText: 'Введите название'),
                      controller: _titleControler,
                    ),
                    const SizedBox(height: 10),
                    const ImageInput(_selectPicture),
                    const SizedBox(height: 10),
                    const LocationInput(_selectPosition),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              _savePlace(context);
              _titleControler.clear();
              _takenPicture = null;
              _savedPosition = null;
            },
            icon: const Icon(Icons.add),
            label: const Text('Добавить место'),
            // crossAxisAlignment.SpaceBetween, MaterialTapTargetSize.shrinkWrap
            // и elevation 0 позволяет кнопке быть в самом низу экрана
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
