import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/utils/utils.dart';
import 'package:flutter_with_firebase/widgets/Round_button.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  File? _image;
  final picker = ImagePicker();

  FirebaseStorage storage = FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future getGalleryImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print("no image picked");
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: (){
                getGalleryImage();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black
                  )
                ),
                child: _image != null? Image.file(_image!.absolute,fit: BoxFit.cover,) : Icon(Icons.image,),
              ),
            ),
          ),
          SizedBox(height: 30,),
          RoundButton (
              title: "Upload",
              onTap: () {
                Reference ref = FirebaseStorage.instance.ref('/foldername/${DateTime.now().millisecondsSinceEpoch}');
                UploadTask upload = ref.putFile(_image!.absolute);

                Future.value(upload).then((value) async{
                  var newUrl = await ref.getDownloadURL();

                  databaseRef.child('1').set({
                    'id' : '121212',
                    'title' : newUrl.toString()
                  }).then((value){
                    Utils().toastMessage("uploaded");
                  });
                });
              })
        ],
      ),
    );
  }
}
