import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/ui/auth/login_screen.dart';
import 'package:flutter_with_firebase/utils/utils.dart';

import 'add_post.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
                builder: (_)=> AddPost()));
          },
          child: Icon(Icons.add)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(

              controller: searchController,
              decoration: InputDecoration(
                hintText: "search",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search)
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),
          // Using FirebaseAnimatedList
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                itemBuilder: (context, snapshot, animation, index){
                  String title= snapshot.child('title').value.toString();
                  if(searchController.text.isEmpty){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                                child: ListTile(
                                  title: Text("Edit"),
                                  leading: Icon(Icons.edit),
                                  onTap: (){
                                    Navigator.pop(context);
                                    showDialogBox(title, snapshot.child('id').value.toString());
                                  },
                                )),
                            PopupMenuItem(
                              value: 1,
                                child: ListTile(
                                  title: Text("Delete"),
                                  leading: Icon(Icons.delete),
                                  onTap: (){
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context){
                                          return AlertDialog(
                                            title: Text("Are you want to Delete?"),
                                            actions: [
                                              TextButton(onPressed: (){
                                                Navigator.pop(context);
                                                ref.child(snapshot.child('id').value.toString()).remove().then((value){
                                                  Utils().toastMessage("Successfully Deleted");
                                                });
                                              }, child: Text("yes")),
                                              TextButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, child: Text("No"))
                                            ],
                                          );
                                        });
                                  },
                                ))
                          ]),
                    );
                  }
                  else if(title.toLowerCase().contains(searchController.text.toLowerCase())){
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  }
                  else{
                    return Container();
                  }
                }),
          )
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
                  ref.child(id).update({
                    'title' : editController.text.toString()
                  }).then((value){
                    Utils().toastMessage("Updated");
                  }).onError((error, stackTrace){
                    Utils().toastMessage(error.toString());
                  });
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



/*
//Using StringBuilder
Expanded(
            child: StreamBuilder(
                stream: ref.onValue,
                builder: (context, snapshot){
                  Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list =[];
                  list.clear();
                  list= map.values.toList();

                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                  }else{
                    return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            title: Text(list[index]['title']),
                            subtitle: Text(list[index]['id']),
                          );
                        });
                  }
                }),
          ),
 */
