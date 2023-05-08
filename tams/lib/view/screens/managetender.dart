import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tams/models/asset.dart';
import 'package:tams/models/tender.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/newtenderscreen.dart';
import 'package:tams/view/shared/config.dart';
import 'package:http/http.dart' as http;

class OpenTender extends StatefulWidget {
  final User user;
  const OpenTender({super.key, required this.user});

  @override
  State<OpenTender> createState() => _OpenTenderState();
}

class _OpenTenderState extends State<OpenTender> {
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
    print("dispose");
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
          appBar: AppBar(
              title:
                  const Text("Manage Tender", style: TextStyle(fontSize: 17))),
          body: tenderList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "All the assets(${tenderList.length} found)",
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
                                    Column(children: [
                                      // Flexible(
                                      //   flex: 5,
                                      //   child: CachedNetworkImage(
                                      //     width: resWidth / 1,
                                      //     fit: BoxFit.cover,
                                      //     imageUrl:
                                      //         "${ServerConfig.SERVER}assets/assetsimages/${assetList[index].productId}.png",
                                      //     placeholder: (context,
                                      //             url) =>
                                      //         const LinearProgressIndicator(),
                                      //     errorWidget: (context,
                                      //             url, error) =>
                                      //         const Icon(
                                      //             Icons.error),
                                      //   ),
                                      // ),
                                      Row(
                                        children: [
                                          Text(
                                            tenderList[index]
                                                .productName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "RM ${double.parse(tenderList[index].productPrice.toString()).toStringAsFixed(2)}/unit"),
                                          Text(
                                              "${(tenderList[index].productQty)} unit"),
                                        ],
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                            );
                          }))
                ])),
    );
  }

  // void createNewTender() {
  //   searchproductIdController.text = "";
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //           builder: (context, StateSetter setState) {
  //             return AlertDialog(
  //               title: const Text(
  //                 "Insert Product Id to Open Tender",
  //                 style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black),
  //               ),
  //               content: SizedBox(
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     TextField(
  //                       controller: searchproductIdController,
  //                       decoration: InputDecoration(
  //                           labelText: 'Product Id',
  //                           border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(10.0))),
  //                     ),
  //                     const SizedBox(height: 5),
  //                   ],
  //                 ),
  //               ),
  //               actions: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         search = searchproductIdController.text;
  //                         Navigator.of(context).pop();
  //                         _loadsearchProductId(search, 1);
  //                       },
  //                       child: const Text(
  //                         "Search",
  //                         style: TextStyle(fontSize: 20, color: Colors.white),
  //                       ),
  //                     ),
  //                   ],
  //                 )
  //               ],
  //             );
  //           },
  //         );
  //       });
  // }

  // void _loadsearchProductId(String search, int pageno) {
  //   curpage = pageno;
  //   numofpage ?? 1;

  //   http
  //       .get(
  //     Uri.parse(
  //         "${ServerConfig.SERVER}php/loadsearchAsset.php?search=$search&pageno=$pageno"),
  //   )
  //       .then((response) {
  //     ProgressDialog progressDialog = ProgressDialog(
  //       context,
  //       blur: 5,
  //       message: const Text("Loading..."),
  //       title: null,
  //     );
  //     progressDialog.show();
  //     if (response.statusCode == 200) {
  //       var jsondata = jsonDecode(response.body);
  //       if (jsondata['status'] == 'success') {
  //         //check if status data array is success
  //         var extractdata = jsondata['data'];
  //         if (extractdata['asset'] != null) {
  //           numofpage = int.parse(jsondata['numofpage']);
  //           numberofresult = int.parse(jsondata['numberofresult']);
  //           assetList = <Asset>[];
  //           extractdata['asset'].forEach((v) {
  //             assetList.add(Asset.fromJson(v));
  //           });
  //           titlecenter = "Found";
  //         } else {
  //           titlecenter = "No Assets Available";
  //           assetList.clear();
  //         }
  //       }
  //     } else {
  //       titlecenter = "No Assets Available";
  //       assetList.clear();
  //     }
  //     setState(() {});
  //     progressDialog.dismiss();
  //   });
  // }

  Future<void> _showDetails(int index) async {
    Asset asset = Asset.fromJson(assetList[index].toJson());
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => NewTender(
                  asset: asset,
                  user: widget.user,
                )));
    _loadTender();
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
}
