import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equipment_request/screens/equipment_details.dart';
import 'package:flutter/material.dart';

class Equipments extends StatelessWidget {
  Equipments({Key? key, required this.isAssigned}) : super(key: key);

  final bool isAssigned;

  final CollectionReference _equipments =
      FirebaseFirestore.instance.collection('equipments');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: StreamBuilder<QuerySnapshot>(
        stream:
            _equipments.where('isAssigned', isEqualTo: isAssigned).snapshots(),
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
                        child: Hero(
                            tag: equipment['picture'],
                            child: Image.network(equipment['picture']))),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EquipmentDetails(equipment: equipment)));
                    }),
              );
            },
          );
        },
      ),
    ));
  }
}
