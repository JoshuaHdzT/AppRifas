import 'package:app/Pages/AddRifa.dart';
import 'package:app/Pages/BoletoRifa.dart';
import 'package:app/Pages/Login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


//stf

class RifaPage extends StatefulWidget {
  const RifaPage({super.key});

  @override
  State<RifaPage> createState() => _RifaPageState();
}

class _RifaPageState extends State<RifaPage> {

  late final String idDoc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuestras Rifas"),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('rifas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index){
                final DocumentSnapshot rifa = docs[index];
                return ListTile(
                  leading: Image.network(rifa['UrlFoto']),

                  title: Text(rifa['nombre']),
                  subtitle: Text(rifa['Descripcion']),
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        BoletoRifa(idDoc: rifa.id,)),);

                  },
                );
              }
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),
          );

        },
        child: Icon(Icons.account_circle_outlined),
      ),
    );
    return const Placeholder();
  }
}
