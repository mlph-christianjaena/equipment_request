import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({Key? key, required this.equipment}) : super(key: key);

  final DocumentSnapshot equipment;

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();

  String employeeName = '', position = '', purpose = '';

  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    final CollectionReference equipments =
        FirebaseFirestore.instance.collection('equipments');

    return Scaffold(
        appBar: AppBar(title: const Text('Request Form')),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    employeeName = value;
                  },
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Name *',
                      contentPadding: const EdgeInsets.all(19)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter employee position';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    position = value;
                  },
                  enabled: true,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Position *',
                      contentPadding: const EdgeInsets.all(19)),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a purpose';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    purpose = value;
                  },
                  enabled: true,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Purpose *',
                      contentPadding: const EdgeInsets.all(19)),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Scheduled Date: ${date.year}/${date.month}/${date.day}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          child: const Text('Select Date'),
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));

                            if (newDate == null) return;
                            setState(() => date = newDate);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Processing Data...'),
                              backgroundColor: Colors.yellow,
                            ),
                          );

                          await equipments
                              .doc(widget.equipment.id)
                              .update({
                                'requesters': [
                                  ...widget.equipment['requesters'],
                                  {
                                    'employeeName': employeeName,
                                    'position': position,
                                    'purpose': purpose,
                                    'schedule': date,
                                  }
                                ]
                              })
                              .then((value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Request success!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  ))
                              .catchError((error) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to submit request: $error'),
                                        backgroundColor: Colors.red),
                                  ));
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
