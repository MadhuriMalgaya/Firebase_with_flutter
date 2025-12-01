import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
 import '../../utils/utils.dart';
import '../../widgets/Round_button.dart';
import '../post/home.dart';

class VerifyCode extends StatefulWidget {
  String verificationId;
VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  TextEditingController verifyCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Verify"),
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
                  controller: verifyCodeController,
                  decoration: InputDecoration(
                    hintText: "6 digit code",
                    label: Text("Phone"),
                    prefixIcon: Icon(Icons.verified_outlined),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Code";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(
                title: "Login",
                loading: loading,
                onTap: () async{
                  loading=loading;

                  if(_formKey.currentState!.validate()){
                    setState(() {
                      loading=true;
                    });
                    final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: verifyCodeController.text.toString());
                    
                    try{
                      await _auth.signInWithCredential(credential);

                      Navigator.push(context, MaterialPageRoute(
                          builder: (_)=> HomeScreen()));
                    }catch(e){
                      setState(() {
                        loading=false;
                      });
                      Utils().toastMessage(e.toString());

                    }
                  }
                })
          ],
        )
    );
  }
}

