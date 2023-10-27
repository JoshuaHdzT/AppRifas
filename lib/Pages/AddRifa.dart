import 'dart:io';

import 'package:app/Pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddRifa extends StatefulWidget {

  final String idDoc;

  const AddRifa({super.key, required this.idDoc});

  @override
  State<AddRifa> createState() => _AddRifaState(this.idDoc);
}

class _AddRifaState extends State<AddRifa> {
  String idDoc;
  CollectionReference rifas = FirebaseFirestore.instance.collection('rifas');
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController numeroBoletoController = TextEditingController();
  final TextEditingController precioBoletoController = TextEditingController();
  DateTime? FechaInicio;
  DateTime? FechaFin;
  final _formAddR = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();
  TextEditingController dateInputt = TextEditingController();
  String? selectedValue;

  final ImagePicker _picker = ImagePicker();
  firebase_storage.Reference? _storageReference;
  File? _image;

  _AddRifaState(this.idDoc) {
    if (idDoc.isNotEmpty) {
      rifas.doc(idDoc).get().then((value) {
        nombreController.text = value['nombre'];
        descripcionController.text = value['Descripcion'];

        numeroBoletoController.text = value['numerodeboleto'].toString();
        precioBoletoController.text = value['presiodeboleto'].toString();
        dateInput.text = value['fechaFin'].toString();
        dateInputt.text = value['fechaInicio'].toString();
        _image= File(value['UrlFoto']);
      });
    }
  }

Future<void> crearBolotes(String rifaId, int cantidad)async{
    for(int i=0;i < cantidad;i++){
      await FirebaseFirestore.instance
          .collection('boletos')
          .add({
        'riid': rifaId, 'numeroBoleto': i+1,
        'reservado': false
      });
    }
}

  Future<void> _getImageFromCamera()async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Rifa "),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          ////////////////////////////////////////
          child: Form(
            key: _formAddR,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: nombreController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        hintText: 'Nombre'),
                    validator: (value) {
                      if (value == "") {
                        return "Este campo es obligatorio";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: descripcionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        hintText: 'Descripcion'),
                    validator: (value) {
                      if (value == "") {
                        return "Este campo es obligatorio";
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: numeroBoletoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        hintText: 'Numero de Boleto'),
                    validator: (value) {
                      if (value == "") {
                        return "Este campo es obligatorio";
                      }
                    },
                  ),
                ),

                /////////////
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextFormField(
                    controller: precioBoletoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        hintText: 'Precio de Boleto'),
                    validator: (value) {
                      if (value == "") {
                        return "Este campo es obligatorio";
                      }
                    },
                  ),
                ),
                ////////////////
                Container(
                    padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.width / 4,
                    child: Center(
                        child: TextField(
                          controller: dateInput,
                          //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Fecha de Inicio" //label text of field
                          ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                              DateFormat('yyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateInput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        ))),
                ////////////Date picker/////
                Container(
                    padding: EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.width / 4,
                    child: Center(
                        child: TextField(
                          controller: dateInputt,
                          //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today), //icon of text field
                              labelText: "Fecha de fin" //label text of field
                          ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateInputt.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {}
                          },
                        )
                    )
                ),
                ////////////Date picker/////

                _image == null
                ? Text('nose encontro ninguna imagen')
                : Image.file(_image!, height: 200.0,),
                ElevatedButton(onPressed: () async{
                  await _getImageFromCamera();
                },
                  child: Text('Tomar foto'),
                ),

                Padding(padding:
                const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                    child: Column(children:<Widget>[
                      Visibility(
                        visible: idDoc.isNotEmpty,
                        child: TextButton(
                          onPressed: () async {
                            var invalid = _formAddR.currentState?.validate();

                            if (invalid == null || invalid == false) {
                              return;
                            }
                            //_login();
                            await rifas.doc(idDoc).delete();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          },
                          style: ButtonStyle(
                            foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.redAccent),
                          ),
                          child: const Text("Borrar"),
                        )
                        ,
                      )
                    ],))

              ],
            ),
          ),

          ////////////////////////////////
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var invalid = _formAddR.currentState?.validate();

          if (invalid == null || invalid == false) {
            return;
          } else {
            //don c uarda la f
            _storageReference = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('carpeta-destino/${DateTime.now()}.png');
            //subir la f
            await _storageReference?.putFile(_image!);
            //obtiene la url de la f
            String? downloadURL = await _storageReference?.getDownloadURL();

            Map<String, dynamic> rifaData = {
              'nombre': nombreController.text,
              'Descripcion': descripcionController.text,
              'numerodeboleto': int.tryParse(numeroBoletoController.text) ?? 0,
              'presiodeboleto':
              double.tryParse(precioBoletoController.text) ?? 0.0,
              'fechaInicio': dateInput.text,
              'fechaFin': dateInputt.text,
              'UrlFoto': downloadURL,
            };

            if (!idDoc.isNotEmpty) {
              var nuevaRifa = await rifas.add(rifaData);
              crearBolotes(nuevaRifa.id, int.tryParse(numeroBoletoController.text)?? 0);
            } else {
              await rifas.doc(idDoc).update(rifaData);

            }
            ////////////////boletos

            //////////////////////

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage()));
            //await boletos.add(rifaData);
          }
        },
        child: Icon(Icons.add),
      ),
    );
    return const Placeholder();
  }
}
