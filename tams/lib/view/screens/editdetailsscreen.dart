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

class EditDetailsScreen extends StatefulWidget {
  final Asset asset;
  final User user;
  const EditDetailsScreen({super.key, required this.asset, required this.user});

  @override
  State<EditDetailsScreen> createState() => _EditDetailsScreenState();
}

class _EditDetailsScreenState extends State<EditDetailsScreen> {
  var pathAsset = "assets/images/takephoto.png";
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
  File? _image;
  bool _isChecked = false;
  late double screenHeight, screenWidth, resWidth;

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
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(title: Text("Details to edit")),
      body: SingleChildScrollView(
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
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const Text(
            "Asset details to edit",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                              icon: Icon(Icons.home_repair_service),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 10)
                              ? "Product description must be longer than 10"
                              : null,
                          maxLines: 4,
                          keyboardType: TextInputType.text,
                          controller: productdescEditingController,
                          decoration: const InputDecoration(
                              labelText: 'Product Description',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(
                                Icons.article,
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
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
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
                        width: 100,
                        child: ElevatedButton(
                          child: const Text('Update'),
                          onPressed: () => {
                            _updateDialog()
                          },
                        ),
                      ),
                    ],
                  )))
        ],
      )),
    );
  }
  
  _updateDialog() {
        if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
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
            "Update this asset details?",
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
                _updateassetDetails();
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
  
  void _updateassetDetails() {
    String productName = productnameEditingController.text;
    String productDesc = productdescEditingController.text;
    String productPrice = productpriceEditingController.text;
    String productQty = productqtyEditingController.text;
    String productType = producttypeEditingController.text;

    http.post(Uri.parse("${ServerConfig.SERVER}php/update_assetdetails.php"), body: {
      "product_id": widget.asset.productId,
      "user_id": widget.user.id,
      "product_name": productName,
      "product_desc": productDesc,
      "product_price": productPrice,
      "product_qty": productQty,
      "product_type": productType,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Successfully updated asset details",
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
