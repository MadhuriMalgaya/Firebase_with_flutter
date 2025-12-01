import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/ui/auth/verify_code.dart';
import 'package:flutter_with_firebase/utils/utils.dart';
import 'package:flutter_with_firebase/widgets/Round_button.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  
  TextEditingController phoneController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login with Phone"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "+91 9545688999",
                  label: Text("Phone"),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value){
                  if(value!.isEmpty){
                   return "Enter Phone";
                  }
                  return null;
                  },
              ),
            ),
          ),
          SizedBox(height: 30,),
          RoundButton(
              title: "Get Otp",
              loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    loading= true;
                  });
                  _auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text,
                      verificationCompleted: (_){
                        setState(() {
                          loading=  false;
                        });
                      },
                      verificationFailed: (e){
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading=  false;
                      });
                      },
                      codeSent: (String verificationId, int? token){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (_)=> VerifyCode(verificationId: verificationId)));
                      setState(() {
                        loading=  false;
                      });
                      },
                      codeAutoRetrievalTimeout: (e){
                      Utils().toastMessage(e.toString());
                      setState(() {
                        loading=  false;
                      });
                      });

                }
              })
        ],
      )
    );
  }
}
