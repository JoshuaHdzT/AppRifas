import 'package:app/Pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _form = GlobalKey<FormState>();
  final txtUserController =TextEditingController();
  final txtPasswordController =TextEditingController();



  Future<void> _login() async {
    try
    {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(email: txtUserController.text, password: txtPasswordController.text);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

    } //try
    catch(e)
  {
    print("ocurrio un error"+ e.toString());
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Oops...',
      text: 'Sorry, something went wrong',
    );
     }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body:
      Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network("https://cdn.pixabay.com/photo/2016/10/10/14/46/icon-1728549_1280.jpg", width: 210,),
              Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: TextFormField(
                controller: txtUserController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Usuario'),
                validator: (value){
                  if(value ==""){
                    return "Este campo es obligatorio";
                  }
                },
              ),
      ),
        Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child:TextFormField(
              controller: txtPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'CONTRASEÑA'),
              validator: (value){
                if(value ==""){
                  return "Este campo es obligatorio";
                }
              },
            ),
        ),
            TextButton(
              onPressed: () {
                var invalid = _form.currentState?.validate();

                if(invalid == null || invalid == false){
                  return;
                }
                _login();
              },
              style: ButtonStyle(
                foregroundColor:
                MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text("Accesar"),
            ),
          ],
        ),
      )

    );
  }
}
