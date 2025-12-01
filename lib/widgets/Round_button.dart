import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  
  final String title;
  final VoidCallback onTap;
  bool loading ;
  
   RoundButton({super.key, required this.title, required this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
          margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red
        ),
        child: Center(
          child: loading? CircularProgressIndicator(strokeWidth: 3, color: Colors.white,):
          Text(title, style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
