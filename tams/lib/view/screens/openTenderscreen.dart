import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:tams/models/asset.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/tenderAdsScreen.dart';
import 'package:tams/view/screens/manageasset.dart';
import 'package:tams/view/screens/newtenderscreen.dart';
import 'package:tams/view/shared/config.dart';
import 'package:http/http.dart' as http;

class OpenTenderScreen extends StatefulWidget {
  final User user;
  const OpenTenderScreen({
    super.key, required this.user,
  });

  @override
  State<OpenTenderScreen> createState() => _OpenTenderScreenState();
}

class _OpenTenderScreenState extends State<OpenTenderScreen> {
  TextEditingController searchController = TextEditingController();
  String search = "all";
  late double screenHeight, screenWidth, resWidth;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  List<Asset> assetList = <Asset>[];
  String titlecenter = "Loading...";
  int rowcount = 2;
  int numberofresult = 0;
  var numofpage, curpage = 1;
  var color;
  // var staff;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadsearchAsset("all", 1);
    });
  }

  @override
  void dispose() {
    assetList = [];
    print("dispose");
    super.dispose();
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
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 194, 181, 212),
          appBar: AppBar(title: const Text("Open Tender"), 
          ),
          body: assetList.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "All the assets($numberofresult found)",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
              onPressed: _loadSearchDialog,
              child: Text(
                "Search Product Id to Open Tender",
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  color: Colors.black87,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: rowcount,
                        children: List.generate(assetList.length, (index) {
                          return Card(
                            elevation: 8,
                            child: InkWell(
                              onTap: () {
                                _showDetails(index);
                              },
                              child: Column(children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    width: resWidth / 2,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${ServerConfig.SERVER}assets/assetsimages/${assetList[index].productId}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            assetList[index]
                                                .productName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              "RM ${double.parse(assetList[index].productPrice.toString()).toStringAsFixed(2)}/unit"),
                                          Text(
                                          "${(assetList[index].productQty)} unit")
                                        ],
                                      ),
                                    ))
                              ]),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: numofpage,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if ((curpage - 1) == index) {
                            color = Color.fromARGB(255, 159, 145, 110);
                          } else {
                            color = Colors.grey;
                          }
                          return TextButton(
                              onPressed: () =>
                                  {_loadsearchAsset(search, index + 1)},
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(color: color, fontSize: 18),
                              ));
                        },
                      ),
                    ),
                  ],
                ),
    ));
  }
  
  void _loadsearchAsset(String search, int pageno) {
    curpage = pageno;
    numofpage ?? 1;

    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}php/loadsearchAsset.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 5,
        message: const Text("Loading..."),
        title: null,
      );
      progressDialog.show();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          //check if status data array is success
          var extractdata = jsondata['data'];
          if (extractdata['asset'] != null) {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            assetList = <Asset>[];
            extractdata['asset'].forEach((v) {
              assetList.add(Asset.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Assets Available";
            assetList.clear();
          }
        }
      } else {
        titlecenter = "No Assets Available";
        assetList.clear();
      }
      setState(() {});
      progressDialog.dismiss();
    });
  }
  
  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search Product Id",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Product Id',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          search = searchController.text;
                          Navigator.of(context).pop();
                          _loadsearchAsset(search, 1);
                        },
                        child: const Text(
                          "Search",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          );
        });
  }
  
  void _showDetails(int index) {
    Asset asset = Asset.fromJson(assetList[index].toJson());
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => NewTender(
                      user: widget.user,
                      asset: asset,
                    )));
    // if (widget.user.id == "0") {
    //   Fluttertoast.showToast(
    //       msg: "Please register an account",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       fontSize: 14.0);
    //   return;
    // }
    // Asset asset = Asset.fromJson(assetList[index].toJson());
    // loadSingleStaff(index);
    // ProgressDialog progressDialog = ProgressDialog(
    //   context,
    //   blur: 5,
    //   message: const Text("Loading..."),
    //   title: null,
    // );
    // progressDialog.show();
    // Timer(const Duration(seconds: 1), () {
    //   if (staff != null) {
    //     progressDialog.dismiss();
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (content) => AssetDetails(
    //                   user: widget.user,
    //                   asset: asset,
    //                   staff: staff,
    //                 )));
    //   }
    //    progressDialog.dismiss();
    // });
  }
  
  // void loadSingleStaff(int index) {
  //   http.post(Uri.parse("${ServerConfig.SERVER}php/load_staff.php"),
  //       body: {"staffid": assetList[index].userId}).then((response) {
  //     print(response.body);
  //     var jsonResponse = json.decode(response.body);
  //     if (response.statusCode == 200 && jsonResponse['status'] == "success") {
  //       staff = User.fromJson(jsonResponse['data']);
  //     }
  //   });
  // }
}
