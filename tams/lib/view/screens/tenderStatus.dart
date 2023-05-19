import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tams/models/tender.dart';
import 'package:tams/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:tams/view/shared/config.dart';

class TenderStatus extends StatefulWidget {
  final User user;
  const TenderStatus({super.key, required this.user});

  @override
  State<TenderStatus> createState() => _TenderStatusState();
}

class _TenderStatusState extends State<TenderStatus> {
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
        title: const Text("Your Tender Status"),
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
}
