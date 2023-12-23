import 'dart:io';

import 'package:chatapp/screens/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var form = GlobalKey<FormState>();
  var islogin = true;
  var enteredemail = '';
  var enteredpassword = '';
  var isAuthenticating = false;
  var enteredusername = '';
  File? selectedimage;
  void submit() async {
    final isvalid = form.currentState!.validate();
    if (!isvalid || !islogin && selectedimage == null) {
      return null;
    }
    form.currentState!.save();
    try {
      setState(() {
        isAuthenticating = true;
      });
      if (islogin) {
        await firebase.signInWithEmailAndPassword(
            email: enteredemail, password: enteredpassword);
      } else {
        final usercredentials = await firebase.createUserWithEmailAndPassword(
            email: enteredemail, password: enteredpassword);
        final storageref = FirebaseStorage.instance
            .ref()
            .child('user-images')
            .child('${usercredentials.user!.uid}.jpg');
        await storageref.putFile(selectedimage!);
        final imageurl = await storageref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(usercredentials.user!.uid)
            .set({
          'username': enteredusername,
          'email': enteredemail,
          'image_url': imageurl,
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authenticaton failed'),
        ),
      );
      setState(() {
        isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.only(
                left: 20,
                top: 30,
                bottom: 20,
                right: 20,
              ),
              child: Image.asset(
                'assets/images/chat2.png',
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!islogin)
                        UserImagePicker(
                          onpickimage: (pickedimage) {
                            selectedimage = pickedimage;
                          },
                        ),
                      TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'please enter the valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enteredemail = value!;
                        },
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Email Address',
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (!islogin)
                        TextFormField(
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.trim().length < 4) {
                              return 'Please enter the valid username atleast 4 characters';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'UserName',
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
                          onSaved: (value) {
                            enteredusername = value!;
                          },
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password must be atleast 6 characters length';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enteredpassword = value!;
                        },
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        obscureText: true,
                        obscuringCharacter: '*',
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          enabledBorder: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (isAuthenticating) const CircularProgressIndicator(),
                      if (!isAuthenticating)
                        ElevatedButton(
                          onPressed: submit,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                          child: Text(islogin ? 'LogIn' : 'SignUp'),
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      if (!isAuthenticating)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              islogin = !islogin;
                            });
                          },
                          child: Text(islogin
                              ? 'Create an account'
                              : 'Already have an account'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
