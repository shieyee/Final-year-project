import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tams/models/asset.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/screens/editdetailsscreen.dart';
import 'package:tams/view/screens/loginscreen.dart';
import 'package:tams/view/screens/mainscreen.dart';
import 'package:tams/view/screens/newassetscreen.dart';
import 'package:tams/view/screens/registerscreen.dart';
import 'package:http/http.dart' as http;
import 'package:tams/view/shared/config.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ManageAsset extends StatefulWidget {
  final User user;
  const ManageAsset({super.key, required this.user});

  @override
  State<ManageAsset> createState() => _ManageAssetState();
}

class _ManageAssetState extends State<ManageAsset> {
  List<Asset> assetList = <Asset>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(title: const Text("Manage Asset"), actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _loadsearchMAsset();
          },
        ),
      ]),
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
                    "Your current assets (${assetList.length} found)",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                    child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(assetList.length, (index) {
                    return Card(
                      elevation: 8,
                      child: InkWell(
                        onTap: () {
                          _showDetails(index);
                        },
                        onLongPress: () {
                          _deleteDialog(index);
                        },
                        child: Column(
                          children: [
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
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(children: [
                                      Text(
                                        assetList[index].productName.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "RM ${double.parse(assetList[index].productPrice.toString()).toStringAsFixed(2)}/unit"),
                                      Text(
                                          "${(assetList[index].productQty)} unit"),
                                    ])))
                          ],
                        ),
                      ),
                    );
                  }),
                ))
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: newasset,
        child: Icon(Icons.add),
      ),
    );
  }

  void _loadsearchMAsset() {}

  Future<void> newasset() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (content) => NewAsset(user: widget.user)));
    _loadAssets();
  }

  void _loadAssets() {
    if (widget.user.id == "0") {
      //check if the user is registered or not
      Fluttertoast.showToast(
          msg: "Please register an account first", //Show toast
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      titlecenter = "Please register an account";
      setState(() {});
      return; //exit method if true
    }
    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}php/loadmanageAsset.php?user_id=${widget.user.id}"),
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
          if (extractdata['asset'] != null) {
            //check if  array object is not null
            assetList = <Asset>[]; //complete the array object definition
            extractdata['asset'].forEach((v) {
              //traverse asset array list and add to the list object array assetlist
              assetList.add(Asset.fromJson(
                  v)); //add each asset array to the list object array assetList
            });
            titlecenter = "Found";
          } else {
            titlecenter =
                "No Asset Available"; //if no data returned show title center
            assetList.clear();
          }
        }
      } else {
        titlecenter = "No Asset Available"; //status code other than 200
        assetList.clear(); //clear assetlist array
      }
      setState(() {}); //refresh UI
    });
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
            "Delete ${truncateString(assetList[index].productName.toString(), 15)}",
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
                _deleteAsset(index);
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

  Future<void> _showDetails(int index) async {
    Asset asset = Asset.fromJson(assetList[index].toJson());
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => EditDetailsScreen(
                  asset: asset,
                  user: widget.user,
                )));
    _loadAssets();
  }

  void _deleteAsset(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}php/delete_asset.php"), body: {
        "product_id": assetList[index].productId,
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Delete Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadAssets();
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
}
