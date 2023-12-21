import 'package:flutter/material.dart';

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
  void submit() {
    final isvalid = form.currentState!.validate();
    if (isvalid) {
      form.currentState!.save();
      print(enteredemail);
      print(enteredpassword);
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
              height: 70,
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
                      ElevatedButton(
                        onPressed: submit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer),
                        child: Text(islogin ? 'LogIn' : 'SignUp'),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
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
