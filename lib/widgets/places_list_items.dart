import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places_provider.dart';

import '../screens/place_details_screen.dart';

class PlacesListItems extends StatelessWidget {
  const PlacesListItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<PlacesProvider>(context);
    return places.items.isEmpty
        ? const Center(
            child: Text(
                'Местечек пока нет. Добавить новое местечко можно через кнопку сверху справа. ;)'),
          )
        : ListView.builder(
            itemCount: places.items.length,
            itemBuilder: (context, index) => Dismissible(
              key: ValueKey(places.items[index].id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) =>
                  places.deletePlace(places.items[index].id),
              background: Container(
                color: Theme.of(context).errorColor,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 40,
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 15,
                ),
              ),
              child: ListTile(
                leading: Hero(
                  tag: places.items[index].id,
                  child: CircleAvatar(
                    backgroundImage: FileImage(places.items[index].picture),
                  ),
                ),
                title: Text(places.items[index].title),
                subtitle: Text(
                  places.items[index].location!.address!,
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                    PlaceDetailsScreen.routeName,
                    arguments: places.items[index].id),
              ),
            ),
          );
  }
}
