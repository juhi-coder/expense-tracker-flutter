import 'package:expanse_tracker/ui/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final formkey = GlobalKey<FormState>();

  String? name;
  String? category;
  int? amount;

  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        builder: (context, viewmodel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              actions: [
                PopupMenuButton(
                    elevation: 1,
                    position: PopupMenuPosition.under,
                    constraints: BoxConstraints.tight(
                      Size(MediaQuery.of(context).size.width * 0.4,
                          MediaQuery.of(context).size.height * 0.14),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                              child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              const Row(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'My Acount',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              const Row(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ))
                        ])
              ],
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                  key: formkey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: MediaQuery.of(context).size.height * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                                hintText: 'name',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onSaved: (value) => name = value?.trim(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required';
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            decoration: InputDecoration(
                                hintText: 'category',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onSaved: (value) => category = value?.trim(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required';
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(height: 20),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'amount',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onSaved: (value) => amount = int.tryParse(value!),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required';
                              } else if (double.tryParse(value) == null) {
                                return 'amount must be a valid number';
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(height: 40),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                formkey.currentState!.save();
                                viewmodel.postExpenses(
                                    name!, category!, amount!);
                              }
                            },
                            child: const Text('submit'))
                      ],
                    ),
                  )),
            ),
          );
        });
  }
}
