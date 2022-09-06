import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEquipment extends StatefulWidget {
  const AddEquipment({Key? key}) : super(key: key);

  @override
  State<AddEquipment> createState() => _AddEquipmentState();
}

class _AddEquipmentState extends State<AddEquipment> {
  final _formKey = GlobalKey<FormState>();

  final CollectionReference equipments =
      FirebaseFirestore.instance.collection('equipments');

  String equipmentName = '',
      description = '',
      specifications = '',
      picture = '',
      brand = '',
      model = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Add Equipment')),
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
                    equipmentName = value;
                  },
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Equipment Name *',
                      contentPadding: const EdgeInsets.all(10)),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a brand';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    brand = value;
                  },
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Brand *',
                      contentPadding: const EdgeInsets.all(10)),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a model';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    model = value;
                  },
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Model *',
                      contentPadding: const EdgeInsets.all(10)),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    description = value;
                  },
                  enabled: true,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Description *',
                      contentPadding: const EdgeInsets.all(10)),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a specification';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    specifications = value;
                  },
                  enabled: true,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Specifications *',
                      contentPadding: const EdgeInsets.all(10)),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an image url';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    picture = value;
                  },
                  enabled: true,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: const OutlineInputBorder(),
                      errorStyle: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 12, color: Colors.red),
                      labelText: 'Image URL *',
                      contentPadding: const EdgeInsets.all(10)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                              .add({
                                'name': equipmentName,
                                'brand': brand,
                                'model': model,
                                'description': description,
                                'specs': specifications,
                                'picture': picture,
                                'assignedEmployee': {},
                                'requesters': [],
                                'isAssigned': false
                              })
                              .then((value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Added successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  ))
                              .catchError((error) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to add equipment: $error'),
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
