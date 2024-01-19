import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPageTile extends StatelessWidget {
  final IconData tileicon;
  final String title ;
  final String subtitle;

  AccountPageTile({super.key, required this.title,  required this.subtitle, required this.tileicon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation:0.0,
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: () {
          print("Tapped on");
        },
        child: ListTile(
          leading: Icon(tileicon,size: 40.0,),
          title: Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 20.0,
            ),
            textAlign: TextAlign.left,
          ),

          subtitle: Text(
            subtitle,
            style: GoogleFonts.cairo(fontSize: 20.0, color: Colors.black26),
          ),
        ));
  }
}
