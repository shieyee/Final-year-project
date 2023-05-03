import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NewTender extends StatefulWidget {
  const NewTender({super.key});

  @override
  State<NewTender> createState() => _NewTenderState();
}

class _NewTenderState extends State<NewTender> {
  final TextEditingController itemnameEditingController =
      TextEditingController();
  final TextEditingController itemdescEditingController =
      TextEditingController();
  final TextEditingController itempriceEditingController =
      TextEditingController();
      final TextEditingController itemqtyEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(title: const Text("Create Tender")),
      body: Container(padding: EdgeInsets.all(20.0),
      child: ListView(
        children: [
          Form(child: Column(
            children: [
              TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: itemnameEditingController,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Product name must be longer than 3"
                              : null,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Item Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.propane_outlined),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))
                          ),
                          TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 5)
                              ? "Product description must be longer than 5"
                              : null,
                          maxLines: 4,
                          keyboardType: TextInputType.text,
                          controller: itemdescEditingController,
                          decoration: const InputDecoration(
                              labelText: 'Description',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(
                                Icons.description_outlined,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                              Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: itempriceEditingController,
                                validator: (val) => val!.isEmpty
                                    ? "Product price must contain value"
                                    : null,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Price/unit',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.monetization_on),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: itemqtyEditingController,
                                validator: (val) => val!.isEmpty
                                    ? "Product quantity should be more than 0"
                                    : null,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Quantity',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.ballot),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () => {},
                          child: const Text(
                            'Create',
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                color: Colors.black87),
                          ),
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      )
            ],
          ))
        ],
      )),
    );
  }
}
