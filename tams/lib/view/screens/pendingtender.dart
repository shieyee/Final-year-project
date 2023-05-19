import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tams/models/tender.dart';
import 'package:http/http.dart' as http;
import 'package:tams/models/user.dart';
import 'package:tams/view/shared/config.dart';

class PendingTender extends StatefulWidget {
  final User user;
  const PendingTender({super.key, required this.user});

  @override
  State<PendingTender> createState() => _PendingTenderState();
}

class _PendingTenderState extends State<PendingTender> {
  List<Tender> pendingtenderList = <Tender>[];
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadpendingTender();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(
        title: const Text("Approve/Reject Tender"),
      ),
      body: pendingtenderList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Text(
              //     "(${pendingtenderList.length} Tender available)",
              //     style: const TextStyle(
              //         fontSize: 16, fontWeight: FontWeight.bold),
              //   ),
              // ),
              SizedBox(height: 10),
              Expanded(
                  child: ListView.builder(
                      itemCount: pendingtenderList.length,
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
                                          "Tender Id: ${(pendingtenderList[index].tenderId)}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                    ]),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                          "Product Name: ${(pendingtenderList[index].productName.toString())}",
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(children: [
                                      const SizedBox(width: 15),
                                      Text(
                                          "Price: RM ${double.parse(pendingtenderList[index].productPrice.toString()).toStringAsFixed(2)}/unit"),
                                    ]),
                                    const SizedBox(height: 8),
                                    Row(children: [
                                      const SizedBox(width: 15),
                                      Text(
                                          "Quantity: ${(pendingtenderList[index].productQty)} unit"),
                                      const SizedBox(height: 8),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 80.0,
                                            height: 25.0,
                                            decoration: BoxDecoration(
                                              color: getColorForTenderStatus(
                                                  pendingtenderList[index]
                                                      .tenderPending),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${pendingtenderList[index].tenderPending}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10)
                                    ]),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }))
            ]),
    );
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
              Text("Tender Id: ${(pendingtenderList[index].tenderId)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                "Product Id: ${(pendingtenderList[index].productId.toString())}",
              ),
              const SizedBox(height: 4),
              Text(
                "Product Name: ${(pendingtenderList[index].productName.toString())}",
              ),
              const SizedBox(height: 4),
              Text(
                "Description: ${(pendingtenderList[index].productDesc.toString())}",
              ),
              const SizedBox(height: 4),
              Text(
                  "Price: RM ${double.parse(pendingtenderList[index].productPrice.toString()).toStringAsFixed(2)}/unit"),
              const SizedBox(height: 4),
              Text("Quantity: ${(pendingtenderList[index].productQty)} unit"),
              const SizedBox(height: 4),
              Text(
                "Type: ${(pendingtenderList[index].productType.toString())}",
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _approveTenderDialog(index);
                  },
                  child: Text('APPROVE'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _rejectTenderDialog(index);
                  },
                  child: Text('REJECT'),
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

  void _approveTenderDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Approve Tender Id: ${truncateString(pendingtenderList[index].tenderId.toString(), 15)}?",
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
                _approveTender(index);
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

  void _rejectTenderDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Reject Tender Id: ${truncateString(pendingtenderList[index].tenderId.toString(), 15)}?",
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
                _approveTender(index);
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

  void _loadpendingTender() {
    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}php/load_pendingTender.php?user_id=${widget.user.id}"),
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
          if (extractdata['pendingtender'] != null) {
            //check if  array object is not null
            pendingtenderList =
                <Tender>[]; //complete the array object definition
            extractdata['pendingtender'].forEach((v) {
              //traverse asset array list and add to the list object array assetlist
              pendingtenderList.add(Tender.fromJson(
                  v)); //add each asset array to the list object array assetList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Tender Available"; //if no data returned show title center
            pendingtenderList.clear();
          }
        }
      } else {
        titlecenter = "No Tender Available"; //status code other than 200
        pendingtenderList.clear(); //clear assetlist array
      }
      setState(() {}); //refresh UI
    });
  }

  getColorForTenderStatus(String? tenderPending) {
    switch (tenderPending) {
      case "Approve":
        return Colors.greenAccent[700];

      case "Reject":
        return Colors.red;

      default:
        return Colors.grey[400];
    }
  }

  void _approveTender(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}php/reject_tender.php"),
          body: {
            "tender_id": pendingtenderList[index].tenderId,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Tender REJECTED!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadTender();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Tender failed reject",
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

  void _loadTender() {
    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}php/load_pendingtender.php?user_id=${widget.user.id}"),
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
          if (extractdata['pendingtender'] != null) {
            //check if  array object is not null
            pendingtenderList =
                <Tender>[]; //complete the array object definition
            extractdata['pendingtender'].forEach((v) {
              //traverse asset array list and add to the list object array assetlist
              pendingtenderList.add(Tender.fromJson(
                  v)); //add each asset array to the list object array assetList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Tender Available"; //if no data returned show title center
            pendingtenderList.clear();
          }
        }
      } else {
        titlecenter = "No Tender Available"; //status code other than 200
        pendingtenderList.clear(); //clear assetlist array
      }
      setState(() {}); //refresh UI
    });
  }
}
