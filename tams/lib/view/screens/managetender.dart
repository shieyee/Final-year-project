import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tams/models/asset.dart';
import 'package:tams/models/tender.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/tenderAdsScreen.dart';
import 'package:tams/view/screens/newtenderscreen.dart';
import 'package:tams/view/shared/config.dart';
import 'package:http/http.dart' as http;

class ManageTender extends StatefulWidget {
  final User user;
  const ManageTender({super.key, required this.user});

  @override
  State<ManageTender> createState() => _ManageTenderState();
}

class _ManageTenderState extends State<ManageTender> {
  List<Asset> assetList = <Asset>[];
  List<Tender> tenderList = <Tender>[];
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  var color;
  int numberofresult = 0;
  var numofpage, curpage = 1;
  String titlecenter = "Loading...";
  String search = "all";
  TextEditingController searchproductIdController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadTender();
  }

  @override
  void dispose() {
    tenderList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 500) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 194, 181, 212),
          appBar: AppBar(title: const Text("Manage Tender")),
          body: tenderList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "(${tenderList.length} Tender found)",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                      child: ListView.builder(
                          itemCount: tenderList.length,
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
                                              "Tender Id: ${(tenderList[index].tenderId)}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const SizedBox(width: 15),
                                            Text(
                                              "Product Name: ${(tenderList[index].productName.toString())}",
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(children: [
                                          const SizedBox(width: 15),
                                          Text(
                                              "Price: RM ${double.parse(tenderList[index].productPrice.toString()).toStringAsFixed(2)}/unit"),
                                        ]),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const SizedBox(width: 15),
                                            Text(
                                              "Quantity: ${tenderList[index].productQty} unit",
                                            ),
                                            const SizedBox(height: 8),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                  width: 40.0,
                                                  height: 25.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        getColorForTenderStatus(
                                                            tenderList[index]
                                                                .tenderStatus),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${tenderList[index].tenderStatus}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10)
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }))
                ])),
    );
  }

  void _loadTender() {
    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}php/loadtender.php?user_id=${widget.user.id}"),
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
          if (extractdata['tender'] != null) {
            //check if  array object is not null
            tenderList = <Tender>[]; //complete the array object definition
            extractdata['tender'].forEach((v) {
              //traverse asset array list and add to the list object array assetlist
              tenderList.add(Tender.fromJson(
                  v)); //add each asset array to the list object array assetList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Asset Available"; //if no data returned show title center
            tenderList.clear();
          }
        }
      } else {
        titlecenter = "No Asset Available"; //status code other than 200
        tenderList.clear(); //clear assetlist array
      }
      setState(() {}); //refresh UI
    });
  }

  void _showDetails(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Details'),
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
              Text("Tender Id: ${(tenderList[index].tenderId)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                "Product Id: ${(tenderList[index].productId.toString())}",
              ),
              const SizedBox(height: 4),
              Text(
                "Product Name: ${(tenderList[index].productName.toString())}",
              ),
              const SizedBox(height: 4),
              Text(
                "Description: ${(tenderList[index].productDesc.toString())}",
              ),
              const SizedBox(height: 4),
              Text(
                  "Price: RM ${double.parse(tenderList[index].productPrice.toString()).toStringAsFixed(2)}/unit"),
              const SizedBox(height: 4),
              Text("Quantity: ${(tenderList[index].productQty)} unit"),
              const SizedBox(height: 4),
              Text(
                "Type: ${(tenderList[index].productType.toString())}",
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    _deleteDialog(index);
                  },
                  icon: Icon(Icons.delete),
                ),
                ElevatedButton(
                  onPressed: () {
                    _closeTenderDialog(index);
                  },
                  child: Text('CLOSE Tender'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void _deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Delete Tender Id: ${truncateString(tenderList[index].tenderId.toString(), 15)}",
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
                _deleteTender(index);

                // Reload tender list
                _loadTender();

                // Close show details dialog
                Navigator.of(context).pop();
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

  void _deleteTender(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}php/delete_tender.php"),
          body: {
            "tender_id": tenderList[index].tenderId,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Delete Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadTender();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Delete Failed",
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

  void _closeTenderDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Close Tender Id: ${truncateString(tenderList[index].tenderId.toString(), 15)}",
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
                _closeTender(index);
                _loadTender();
                Navigator.of(context).pop();
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

  void _closeTender(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}php/close_tender.php"), body: {
        "tender_id": tenderList[index].tenderId,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Tender was successfully CLOSED",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadTender();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Tender failed to close",
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

  getColorForTenderStatus(String? tenderStatus) {
    switch (tenderStatus) {
      case "Close":
        return Colors.red;

      default:
        return Colors.greenAccent[700];
    }
  }
}
