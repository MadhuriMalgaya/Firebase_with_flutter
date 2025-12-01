import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/ui/auth/login_screen.dart';

import 'add_post_in_firestore.dart';


class FireStoreListScreen extends StatefulWidget {
  const FireStoreListScreen({super.key});

  @override
  State<FireStoreListScreen> createState() => _FireStoreListScreenState();
}

class _FireStoreListScreenState extends State<FireStoreListScreen> {

  final auth = FirebaseAuth.instance;
  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();
  
  final getData= FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FireStore Screen"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed:(){
                auth.signOut();
                Navigator.push(context, MaterialPageRoute(
                    builder:(_)=> LoginScreen()));
              },
              icon: Icon(Icons.login_outlined)),
          SizedBox(width: 10,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (_)=> AddPostInFireStore()));
          },
          child: Icon(Icons.add)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
              stream: getData,
              builder: (context, snapshot){
                if(snapshot.connectionState== ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else if(snapshot.hasError){
                  return Text("Some Error");
                }
                else{
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            title: Text(snapshot.data!.docs[index]['title'].toString()),
                            subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                            onTap: (){
                              // ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                              //   'title' : 'something'
                              // });
                              ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
                            },
                          );
                        }),
                  );
                }
              })
        ],
      ),
    );
  }

  Future<void> showDialogBox(String title, String id) async{
    editController.text = title;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Update"),
            content: TextField(
              controller: editController,
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Update")),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          );
        }
    );
  }
}
