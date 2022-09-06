import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equipment_request/screens/request_form.dart';
import 'package:equipment_request/utilities/months.dart';
import 'package:flutter/material.dart';

class EquipmentDetails extends StatelessWidget {
  const EquipmentDetails({Key? key, required this.equipment}) : super(key: key);

  final DocumentSnapshot equipment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment Details')),
      body: Column(
        children: [
          equipmentDetails(equipment),
          !equipment['isAssigned']
              ? Column(children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RequestForm(
                                      equipment: equipment,
                                    )));
                      },
                      child: const Text('Request')),
                ])
              : employeeDetails(context, equipment),
        ],
      ),
    );
  }
}

Widget equipmentDetails(equipment) {
  return Container(
    margin: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          child: Hero(
            tag: equipment['picture'],
            child: Image.network(
              equipment['picture'],
            ),
          ),
        ),
        Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Equipment Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'Equipment Name: ${equipment['name']}',
                  ),
                  Text('Brand: ${equipment['brand']}'),
                  Text('Model: ${equipment['model']}'),
                  Text('Description: ${equipment['description']}'),
                  Text('Specifications: ${equipment['specs']}'),
                  Text('Equipment Code: ${equipment.id}'),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget employeeDetails(context, equipment) {
  final employee = equipment['assignedEmployee'];
  DateTime date = (employee['schedule'] as Timestamp).toDate();
  return Card(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assigned Employee Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text('Name: ${employee['employeeName']}'),
              Text('Position: ${employee['position']}'),
              Text('Purpose: ${employee['purpose']}'),
              Text(
                  'Schedule: ${months[date.month - 1]} ${date.day}, ${date.year}'),
            ],
          ),
        ),
      ],
    ),
  );
}
