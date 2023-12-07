import 'package:capstone_project/patient_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewPatientPage extends StatefulWidget {
  const NewPatientPage({super.key});

  @override
  State<NewPatientPage> createState() => _NewPatientPageState();
}

class _NewPatientPageState extends State<NewPatientPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'New Patient',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('New Patient'),
            centerTitle: true,
            leading: BackButton(onPressed: () {
              Navigator.pop(context);
            }),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(children: [
                Form(
                    child: Column(
                  key: _formKey,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: TextFormField(
                          decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Name'),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: TextFormField(
                          decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Gender'),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: InputDatePickerFormField(
                          firstDate: DateTime(1900), lastDate: DateTime(2023)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Height (ft)'),
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only numbers can be entered
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text('Height (in)'),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers can be entered
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Weight (lbs)'),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: TextFormField(
                          decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Sport'),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: TextFormField(
                          decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Third Party ID'),
                      )),
                    ),
                  ],
                )),
              ]),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
              surfaceTintColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel',
                                style: TextStyle(fontSize: 20))),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        FilledButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PatientPage(),
                                ),
                              );
                            },
                            child: const Text('Submit',
                                style: TextStyle(fontSize: 20))),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
