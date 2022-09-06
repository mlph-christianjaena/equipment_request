import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equipment_request/utilities/months.dart';
import 'package:flutter/material.dart';

class AssignEquipment extends StatelessWidget {
  AssignEquipment({Key? key, required this.requesters, required this.equipment})
      : super(key: key);

  final List requesters;
  final DocumentSnapshot equipment;

  final CollectionReference equipments =
      FirebaseFirestore.instance.collection('equipments');

  @override
  Widget build(BuildContext context) {
    if (requesters.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Assign Equipment'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: requesters.length,
            itemBuilder: (context, index) {
              final requester = requesters[index];
              DateTime date = (requester['schedule'] as Timestamp).toDate();
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                    contentPadding: const EdgeInsets.all(15.0),
                    title: Text(requester['employeeName']),
                    subtitle: Text(
                        'Position: ${requester['position']}\npurpose: ${requester['purpose']}\nSchedule: ${months[date.month - 1]} ${date.day}, ${date.year}'),
                    leading: const CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person)),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Processing Data...',
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Colors.yellow,
                        ),
                      );

                      await equipments
                          .doc(equipment.id)
                          .update({
                            'isAssigned': true,
                            'assignedEmployee': {
                              'employeeName': requester['employeeName'],
                              'position': requester['position'],
                              'purpose': requester['purpose'],
                              'schedule': requester['schedule'],
                            }
                          })
                          .then((value) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Assigned successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              ))
                          .catchError((error) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Failed to submit assign: $error'),
                                    backgroundColor: Colors.red),
                              ));
                    }),
              );
            },
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Assign Equipment'),
        ),
        body: const Center(
          child: Text('No requests for this equipment yet.'),
        ),
      );
    }
  }
}
