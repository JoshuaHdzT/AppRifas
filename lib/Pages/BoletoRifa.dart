import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BuyTickets.dart';

class BoletoRifa extends StatefulWidget {
  final String idDoc;
  const BoletoRifa({super.key, required this.idDoc});

  @override
  State<BoletoRifa> createState() => _BoletoRifaState(this.idDoc);
}

class _BoletoRifaState extends State<BoletoRifa> {
  String idDoc;

  _BoletoRifaState(this.idDoc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boletos"),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('boletos')
            .where('riid', isEqualTo: widget.idDoc)
            .where('reservado', isEqualTo: false).snapshots(),
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
                  leading: const Icon(Icons.shopping_bag),

                  title: Text(rifa['numeroBoleto'].toString()),
                  subtitle: Text(rifa['reservado'].toString()),
                  onTap:(){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          BuyTickets(idDoc: rifa.id,
                            ticketNumber: rifa ['numeroBoleto'], )),);

                  },
                );
              }
          );

        },
      ),
    );
  }
}
