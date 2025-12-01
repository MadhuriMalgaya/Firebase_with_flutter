import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/ui/auth/login_screen.dart';
import 'package:flutter_with_firebase/utils/utils.dart';

import '../../widgets/Round_button.dart';
import '../../widgets/TextField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

   FirebaseAuth _auth = FirebaseAuth.instance;
   bool loading = false;

  bool obsecureText = true;

  void signUp(){
    setState(() {
      loading=true;
    });
    _auth.createUserWithEmailAndPassword(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString()).then((value){
          Utils().toastMessage("Registered");
      setState(() {
        loading=false;
      });
    }).onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFieldData(
                    controller: _emailController,
                    hintText: "email",
                    label: "Email",
                    prefixIcon: Icons.alternate_email,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFieldData(
                    controller: _passwordController,
                    obscureText: obsecureText,
                    hintText: "password",
                    label: "Password",
                    prefixIcon: Icons.lock,
                    suffixIcon: obsecureText? Icons.visibility_off: Icons.visibility,
                    onSuffixTap: (){
                      setState(() {
                        obsecureText = !obsecureText;
                      });
                    },
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter password';
                      }
                      return null;
                    },
                  ),
                ],
              )),
          SizedBox(height: 30,),
          RoundButton(title: "Sign Up",
            loading: loading,
            onTap: (){
              if(_formKey.currentState!.validate()){
                signUp();
              }
            },),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an Account? "),
              TextButton(onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (_)=> LoginScreen()));
              },
                  child: Text("Login"))
            ],
          )
        ],
      ),
    );
  }
}
