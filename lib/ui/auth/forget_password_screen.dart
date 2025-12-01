import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/utils/utils.dart';
import 'package:flutter_with_firebase/widgets/Round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
        centerTitle: true,
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "email",
                prefixIcon: Icon(Icons.alternate_email)
              ),
            ),
          ),
          SizedBox(height: 20,),
          RoundButton(
              title: "Forget",
              onTap: (){
                auth.sendPasswordResetEmail(
                    email: emailController.text.toString()).then((value){
                      Utils().toastMessage("We have given you reset link on your given mail");
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                });
              })
        ],
      ),
    );
  }
}
