import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'assign_equipment.dart';

class Screening extends StatelessWidget {
  Screening({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> _equipments =
      FirebaseFirestore.instance.collection('equipments').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Screening'),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: _equipments,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot equipment = snapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                        contentPadding: const EdgeInsets.all(15.0),
                        title: Text(equipment['name']),
                        subtitle: Text(
                            'Description: ${equipment['description']}\nSpecs: ${equipment['specs']}\nEquipment Code: ${equipment.id}'),
                        leading: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.white,
                            child: Image.network(equipment['picture'])),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AssignEquipment(
                                      requesters: equipment['requesters'],
                                      equipment: equipment)));
                        }),
                  );
                },
              );
            },
          ),
        ));
  }
}
