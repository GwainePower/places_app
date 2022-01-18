import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathprovider;

class ImageInput extends StatefulWidget {
  const ImageInput(this.onSelectPicture, {Key? key}) : super(key: key);

  final Function onSelectPicture;

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedPicture;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture(ImageSource source) async {
    final takenPicture = await _picker.pickImage(
      source: source,
      maxWidth: 800,
    );
    if (takenPicture == null) {
      return;
    }
    setState(() => _storedPicture = File(takenPicture.path));
    final appDir = await pathprovider.getApplicationDocumentsDirectory();
    final fileName = path.basename(takenPicture.path);
    final savedPicture = await _storedPicture!.copy('${appDir.path}/$fileName');
    widget.onSelectPicture(savedPicture);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _storedPicture != null
              ? Image.file(
                  _storedPicture!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'Где фотка то',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => SimpleDialog(
                title: const Text('Откуда фотку берем?'),
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _takePicture(ImageSource.camera);
                    },
                    child: const Text('Врубить камеру'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _takePicture(ImageSource.gallery);
                    },
                    child: const Text('Выбрать из галереи'),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Добавить фотку'),
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }
}
