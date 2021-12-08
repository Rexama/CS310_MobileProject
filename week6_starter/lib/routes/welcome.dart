import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:week6_starter/utils/dimension.dart';
import 'package:flutter/material.dart';
import 'package:week6_starter/utils/color.dart';
import 'package:week6_starter/utils/styles.dart';
import 'package:animate_do/animate_do.dart';

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
                opacity: 0.31,
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
                  child:
                  FadeInUp(
                    delay: Duration(milliseconds: 300),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      'Welcome!',
                        style: GoogleFonts.nunito(
                        color: AppColors.whiteBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ),
                ),

                SizedBox(height:17),

                Padding(padding: const EdgeInsets.symmetric(horizontal: 30),
                  child:
                  FadeInUp(
                    delay: Duration(milliseconds: 400),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      'The best of news all in one place. Trusted sources and personalized news for you.',
                      style: GoogleFonts.nunito(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60,),
              ],
            ),
            Column(

              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                FadeInUp(
                  delay: Duration(milliseconds: 500),
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Container(
                      height: 50,
                      width: 320,

                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFF1B263B),
                              Color(0xFF778DA9),

                            ]
                        ),
                        //color: Color(0xFF464646)

                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Center(
                          child:
                            Text("Sign Up", style: GoogleFonts.nunito(
                              color: AppColors.whiteBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                     ),
                  ),
                SizedBox(height: 20),

                FadeInUp(
                  delay: Duration(milliseconds: 600),
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Container(
                      height: 50,
                      width: 320,

                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFFffc971),
                              Color(0xbfff8800),
                            ]
                        ),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Center(
                          child: Text("Login",
                            style: GoogleFonts.nunito(
                              color: AppColors.whiteBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),

                  )
                ),
                SizedBox(height: 8),

                FadeInUp(
                  delay: Duration(milliseconds: 700),
                  duration: Duration(milliseconds: 1000),
                  child: TextButton(
                    onPressed: () {},
                    child: Center(
                      child: Text(
                        'Continue without login', //Attempt: ${count!=null ? count:0}',
                        style: TextStyle(color: Colors.white,fontSize: 15),
                      ),
                    ),
                  )

                ),
                SizedBox(height: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
