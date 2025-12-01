import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_firebase/ui/auth/forget_password_screen.dart';
import 'package:flutter_with_firebase/ui/auth/login_with_phone.dart';
import 'package:flutter_with_firebase/ui/auth/sign_up_screen.dart';
import 'package:flutter_with_firebase/widgets/Round_button.dart';
import 'package:flutter_with_firebase/widgets/TextField.dart';
import '../../utils/utils.dart';
import '../post/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _login = FirebaseAuth.instance;
  bool loading= false;

  bool obsecureText = true;

  void login(){
    setState(() {
      loading= true;
    });
    _login.signInWithEmailAndPassword(
        email: _emailController.text.toString(),
        password: _passwordController.text.toString()).then((value){
          Utils().toastMessage("Successfully login");
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => HomeScreen()));
      setState(() {
        loading= false;
      });
    }).onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading= false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
       },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
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
                RoundButton(title: "Login",
                loading: loading,
                onTap: (){
                  if(_formKey.currentState!.validate()){
                    login();
                  }
                },),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ForgetPasswordScreen()));
                      },
                      child: Text("Forget Password")),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an Account? "),
                    TextButton(onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_)=> SignUpScreen()));
                    },
                        child: Text("Sign up"))
                  ],
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_)=> LoginWithPhone()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.black
                      )
                    ),
                    child: Center(
                      child: Text("Login with phone"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
