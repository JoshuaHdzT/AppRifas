import 'package:app/Pages/AddRifa.dart';
import 'package:app/Pages/RifaPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//stf

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final String idDoc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Column(
                children: [
                  Expanded(child: Image.network("https://cdn-icons-png.flaticon.com/512/7864/7864790.png")),
                  Text("Usuario")
                ],
              )
              ),
              ListTile(
                leading: Icon(Icons.monetization_on),
                title: Text("Rifas"),
                onTap: (){

                },
              ),
              ListTile(
                leading: Icon(Icons.monetization_on),
                title: Text("Rifas Cliente"),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RifaPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.payment_sharp),
                title: Text("Boletos Apartados"),
                onTap: (){

                },

              ),
            ],
          ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRifa(idDoc: rifa.id,)),
                      );

                    },
                  );
                  }
              );

          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddRifa(idDoc:'',)),
          );

        },
      child: Icon(Icons.add),
      ),
        );
    return const Placeholder();
  }
}
