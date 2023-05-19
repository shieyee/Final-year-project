import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tams/models/tender.dart';
import 'package:http/http.dart' as http;
import 'package:tams/models/user.dart';
import 'package:tams/view/shared/config.dart';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class TenderAds extends StatefulWidget {
  final User user;
  const TenderAds({super.key, required this.user});

  @override
  State<TenderAds> createState() => _TenderAdsState();
}

class _TenderAdsState extends State<TenderAds> {
  List<Tender> tenderList = <Tender>[];
  FilePickerResult? result;
  String titlecenter = "Loading...";
  List<Tender> opentenderList = <Tender>[];

  @override
  void initState() {
    super.initState();
    _loadTender();
  }

  @override
  void dispose() {
    opentenderList = [];
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 194, 181, 212),
          appBar: AppBar(title: const Text("Tender Advertisements")),
          body: opentenderList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "(${opentenderList.length} Tender available)",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: ListView.builder(
                          itemCount: opentenderList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  _showDetails(index);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Column(
                                      children: [
                                        Row(children: [
                                          const SizedBox(width: 15),
                                          Text(
                                              "Tender Id: ${(opentenderList[index].tenderId)}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const SizedBox(width: 15),
                                            Text(
                                              "Product Name: ${(opentenderList[index].productName.toString())}",
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(children: [
                                          const SizedBox(width: 15),
                                          Text(
                                              "Price: RM ${double.parse(opentenderList[index].productPrice.toString()).toStringAsFixed(2)}/unit"),
                                        ]),
                                        const SizedBox(height: 8),
                                        Row(children: [
                                          const SizedBox(width: 15),
                                          Text(
                                              "Quantity: ${(opentenderList[index].productQty)} unit"),
                                              
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }))
                ]),
        ));
  }

  void _showDetails(int index) {
    String? selectedFileName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            Future<void> _uploadDocument() async {
              final result =
                  await FilePicker.platform.pickFiles(allowMultiple: true);
              if (result == null) {
                print("No file selected");
              } else {
                setState(() {
                  selectedFileName = result.files.first.name;
                });
                result.files.forEach((element) {
                  print(element.name);
                });
              }
            }

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Tender Pre-Qualification',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Tender Id: ${(opentenderList[index].tenderId)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Product Id: ${(opentenderList[index].productId.toString())}",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Product Name: ${(opentenderList[index].productName.toString())}",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Description: ${(opentenderList[index].productDesc.toString())}",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Price: RM ${double.parse(opentenderList[index].productPrice.toString()).toStringAsFixed(2)}/unit",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Quantity: ${(opentenderList[index].productQty)} unit",
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Type: ${(opentenderList[index].productType.toString())}",
                  ),
                  OutlinedButton.icon(
                    onPressed: _uploadDocument,
                    icon: Icon(Icons.upload_file_outlined),
                    label: Text('Upload File'),
                  ),
                  if (selectedFileName != null)
                    Text(
                      'Selected File: $selectedFileName',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _submitTenderDialog(index);
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _submitTenderDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Submit your Tender?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                _submitDocument(index);
                _loadTender();
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

  void _loadTender() {
    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}php/load_openTender.php?user_id=${widget.user.id}"),
    )
        .then((response) {
      // wait for response from the request
      if (response.statusCode == 200) {
        //if statuscode OK
        var jsondata =
            jsonDecode(response.body); //decode response body to jsondata array
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data']; //extract data from jsondata array
          if (extractdata['opentender'] != null) {
            //check if  array object is not null
            opentenderList = <Tender>[]; //complete the array object definition
            extractdata['opentender'].forEach((v) {
              //traverse asset array list and add to the list object array assetlist
              opentenderList.add(Tender.fromJson(
                  v)); //add each asset array to the list object array assetList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Tender Available"; //if no data returned show title center
            opentenderList.clear();
          }
        }
      } else {
        titlecenter = "No Tender Available"; //status code other than 200
        opentenderList.clear(); //clear assetlist array
      }
      setState(() {}); //refresh UI
    });
  }

  void _submitDocument(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}php/pending_tender.php"),
          body: {
            "tender_id": opentenderList[index].tenderId,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Tender successfully SUBMITTED",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadTender();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Tender failed to submit",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
