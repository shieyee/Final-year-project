import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tams/models/asset.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/shared/config.dart';
import 'package:http/http.dart' as http;

class NewTender extends StatefulWidget {
  final User user;
  final Asset asset;
  const NewTender({super.key, required this.asset, required this.user});

  @override
  State<NewTender> createState() => _NewTenderState();
}

class _NewTenderState extends State<NewTender> {
  final TextEditingController tenderidEditingController =
      TextEditingController();
  final TextEditingController productnameEditingController =
      TextEditingController();
  final TextEditingController productdescEditingController =
      TextEditingController();
  final TextEditingController productpriceEditingController =
      TextEditingController();
  final TextEditingController productqtyEditingController =
      TextEditingController();
  final TextEditingController producttypeEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, resWidth;
  bool _isChecked = false;
  File? _image;
  
  @override
  void initState() {
    super.initState();
    productnameEditingController.text = widget.asset.productName.toString();
    productdescEditingController.text = widget.asset.productDesc.toString();
    productpriceEditingController.text = widget.asset.productPrice.toString();
    productqtyEditingController.text = widget.asset.productQty.toString();
    producttypeEditingController.text = widget.asset.productType.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      key: _formKey,
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(title: const Text("Create Tender")),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Card(
                color: Color.fromARGB(255, 194, 181, 212),
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}assets/assetsimages/${widget.asset.productId}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: tenderidEditingController,
                  validator: (val) => val!.isEmpty
                      ? "Tender Id must should not be empty"
                      : null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'Tender Id',
                      labelStyle: TextStyle(),
                      icon: Icon(Icons.propane_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ))),
              TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: productnameEditingController,
                  validator: (val) => val!.isEmpty || (val.length < 3)
                      ? "Product name must be longer than 3"
                      : null,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      labelText: 'Product Name',
                      labelStyle: TextStyle(),
                      icon: Icon(Icons.propane_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ))),
              TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (val) => val!.isEmpty || (val.length < 5)
                      ? "Product description must be longer than 5"
                      : null,
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  controller: productdescEditingController,
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
                        controller: productpriceEditingController,
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
                        controller: productqtyEditingController,
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
              Row(children: [
                Flexible(
                  flex: 5,
                  child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: producttypeEditingController,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Type should be longer than 0"
                          : null,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: 'Type',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.interests),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ))),
                ),
                Flexible(
                    flex: 5,
                    child: CheckboxListTile(
                      title: const Text("Policy"), // <‐‐ label
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    )),
              ]),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => {_openTender()},
                  child: const Text(
                    'Create',
                    style: TextStyle(
                        fontSize: 15, letterSpacing: 1, color: Colors.black87),
                  ),
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              )
            ],
          )),
    );
  }

  _openTender() {
    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please agree with the policy",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Open Tender?",
            style: TextStyle(fontSize: 18),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _insertTender();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _insertTender() {
    String productName = productnameEditingController.text;
    String productDesc = productdescEditingController.text;
    String productPrice = productpriceEditingController.text;
    String productQty = productqtyEditingController.text;
    String productType = producttypeEditingController.text;
    String tenderId = tenderidEditingController.text;

     http.post(Uri.parse("${ServerConfig.SERVER}php/insert_tender.php"), body: {
      "product_id": widget.asset.productId,
      "user_id": widget.user.id,
      "product_name": productName,
      "product_desc": productDesc,
      "product_price": productPrice,
      "product_qty": productQty,
      "product_type": productType,
      "tender_id": tenderId,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Successfully open tender",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        return;
      } else {
        Fluttertoast.showToast(
            msg: "Failed to update",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        return;
      }
    });
  }
}
