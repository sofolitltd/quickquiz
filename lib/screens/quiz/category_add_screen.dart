import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "";
    String image = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //title
          TextField(
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              label: Text('Title'),
              hintText: 'Title',
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              title = val;
            },
          ),
          const SizedBox(height: 16),
          //imageUrl
          TextField(
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              label: Text('Image url'),
              hintText: 'Image url',
              contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 8),
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              title = val;
            },
          ),
          const SizedBox(height: 24),

          // add
          ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () async {
                if (title == '') {
                  log('no title');
                  Fluttertoast.showToast(msg: 'Enter a title');
                } else {
                  await addCategory(context, title: title, image: image);
                }
              },
              child: Text('Add Now'.toUpperCase())),
        ],
      ),
    );
  }
}

// add category
addCategory(BuildContext context,
    {required String title, required String image}) async {
  Navigator.pop(context);
  await FirebaseFirestore.instance.collection('quiz').doc().set({
    'title': title.trim(),
    'image': image.trim(),
  });
}
