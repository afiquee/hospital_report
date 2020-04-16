import 'package:flutter/material.dart';
import 'package:hospital_report/models/user.dart';
import 'package:hospital_report/screens/users/user_tile.dart';
import 'package:hospital_report/shared/OtherClipper.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<User>>(context) ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: OtherClipper(),
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[
                          Colors.red[200],
                          Colors.red[400]
                        ]
                    )
                ),
                child: Center(
                  child: Text(
                    'Senarai pengguna',
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 5.0,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height-320,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context,index) {
                  return UserTile(user: users[index]);

                },
              ),
            ),
          ],
        ),
      ),

    );

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context,index) {
        return UserTile(user: users[index]);

      },
    );
  }
}