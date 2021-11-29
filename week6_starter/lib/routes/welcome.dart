import 'package:flutter/cupertino.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:flutter/material.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/styles.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.45,
                child: Image.network(
                    'https://i.pinimg.com/564x/62/c2/30/62c230e25c6239c33d2954641b9f5467.jpg',
                    fit: BoxFit.contain,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [

                Padding(padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                      'Welcome!',
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                    ),
                  ),
                ),

                SizedBox(height:17),

                Padding(padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'The best of news all in one place. Trusted sources and personalized news for you.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Container(
                      height: 50,
                      width: 320,

                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Color(0xFF464646)
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Center(
                          child: Text("Sign Up", style: TextStyle(fontSize: 18,color: Color(0xFFcccccf), fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Container(
                      height: 50,
                      width: 320,

                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFFffb421),
                              Color(0xFFff7521)
                            ]
                        ),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Center(
                          child: Text("Login", style: TextStyle(fontSize: 18,color:Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 150),
                ],
            ),
          ],
        ),
      ),
    );
  }
}