import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_auth/otp.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_phone_auth/sign_in_withGoogle';

class phoneauth extends StatefulWidget {
  const phoneauth({super.key});
  static String verify = "";

  @override
  State<phoneauth> createState() => _phoneauthState();
}

class _phoneauthState extends State<phoneauth> {
  TextEditingController countrycode = TextEditingController();
  var phone = "";
  void intState() {
    countrycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                ' Welcome to FitEarn ',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'you will recieve a 6 digit code to verify next',
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        
                        controller: countrycode,
                        decoration:
                            const InputDecoration(border: InputBorder.none,),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          phone = value;
                        },
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'phone'),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: countrycode.text + phone,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        phoneauth.verify = verificationId;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Myotp()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 202, 10, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text("Continue with mobile",style: TextStyle(color: Colors.white70),),
                ),
               
              ),
              SizedBox(height: 10,),
              SizedBox(height: 45,
              width: double.infinity,
              child: ElevatedButton(onPressed: ()async{
                 try {
              // Step 1: Initialize GoogleSignIn
              final GoogleSignIn googleSignIn = GoogleSignIn();

              // Step 2: Start the Sign-In process
              final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
              if (googleUser == null) {
                // User canceled the sign-in
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign-In Cancelled')),
                );
                return;
              }

              // Step 3: Authenticate
              final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

              // Step 4: Create a new credential
              final OAuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );

              // Step 5: Sign in with Firebase
              final UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithCredential(credential);

              // Step 6: Display success message
              final User? user = userCredential.user;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Welcome, ${user?.displayName}!')),
              );
            } catch (e) {
              // Handle errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sign-In Failed: $e')),
              );
            }  
          
              }, child: Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage('https://w7.pngwing.com/pngs/326/85/png-transparent-google-logo-google-text-trademark-logo-thumbnail.png'),
                ),
                SizedBox(width: 5,),
                Text('sign with Google')
              ],),
              style: ElevatedButton.styleFrom(
               
                
                
               backgroundColor:  Colors.black,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),
               side: BorderSide(color: Colors.white))
                
              )),),
              Center(
                child: Row(
                  children: [
                    Text('don`t have a Account',style: TextStyle(color: Colors.white),),
                    SizedBox(width: 10,),
                    TextButton(onPressed: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => phoneauth()));
                    }, child: Text('sign up',style: TextStyle(color: Colors.white),))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


