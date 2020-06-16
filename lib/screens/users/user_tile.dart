import 'package:flutter/material.dart';
import 'package:hospital_report/models/user.dart';


class UserTile extends StatelessWidget {

  final User user;
  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListTile(
            leading: RichText(
              text: TextSpan(
                  text: user.email, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black , height: 1.5),
                  children: [
                    TextSpan(
                      text: '\n${user.name}', style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
                    ),


                  ]

              ),
            ),
          ),
        ),
      ),
    );
  }
}
