import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  XFile? photo;

  SetImage() async {
    try {
      Reference ref = storage.ref();
      Reference imageRef = ref.child('image/ ${photo!.name}');

      File image = File(photo!.path);

      await imageRef.putFile(image);

      setState(() async {
        image = (await imageRef.getDownloadURL()) as File;
        debugPrintStack(label: "File URL ------>> $photo");
      });
    } on FirebaseException catch (url) {
      debugPrint(toString());
    }
  }

  DeleteImage() async {
    Reference ref = storage.ref();
    Reference imageRef = ref.child('image/ ${photo!.name}');

    await imageRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fire Base"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          GestureDetector(
            onTap: () => pickProfileImage(),
            child: Container(
              height: 400,
              width: 500,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Colors.teal,
              ),
              child: photo != null
                  ? Image.file(
                      File(photo!.path),
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.camera_alt_sharp, size: 90),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              SetImage();
            },
            child: Text('Set Storage'),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              DeleteImage();
            },
            child: Text('delete image'),
          ),
        ],
      ),
    );
  }

  pickProfileImage() async {
    photo = await picker.pickImage(source: ImageSource.gallery);
    debugPrint(photo!.path);
    debugPrint(photo!.name);

    var data = await photo!.readAsBytes();
    debugPrint(data.toString());

    setState(() {});
  }
}
