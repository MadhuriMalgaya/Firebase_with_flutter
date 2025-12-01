import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_with_firebase/utils/utils.dart';
import 'package:flutter_with_firebase/widgets/Round_button.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  TextEditingController postController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref("Post");
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
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
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                databaseRef.child(id).set({
                  'title' : postController.text.toString(),
                  'id': id
                }).then((value){
                  Utils().toastMessage("Post Added");
                  setState(() {
                    loading= false;
                  });
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                  print("error: "+error.toString());
                  setState(() {
                    loading= false;
                  });
                });
                })
          ],
        ),
      ),
    );
  }
}
