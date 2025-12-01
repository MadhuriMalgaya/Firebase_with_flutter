import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/utils/utils.dart';

import '../../widgets/Round_button.dart';


class AddPostInFireStore extends StatefulWidget {
  const AddPostInFireStore({super.key});

  @override
  State<AddPostInFireStore> createState() => _AddPostInFireStoreState();
}

class _AddPostInFireStoreState extends State<AddPostInFireStore> {
  TextEditingController postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add fireStore data"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: InputDecoration(
                hintText: "What is on your Mind?",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(
                title: "post",
                loading: loading,
                onTap: (){
                  setState(() {
                    loading= true;
                  });
                  String id= DateTime.now().millisecondsSinceEpoch.toString();
                  fireStore.doc(id).set({
                    'title': postController.text.toString(),
                    'id': id
                  }).then((value){
                    setState(() {
                      loading= false;
                    });
                    Utils().toastMessage("Successfully Posted");
                  }).onError((error, stackTrace){
                    setState(() {
                      loading= false;
                    });
                    print("error" +error.toString());
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}

