import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tams/models/asset.dart';
import 'package:tams/models/user.dart';
import 'package:tams/view/shared/config.dart';

class AssetDetails extends StatefulWidget {
  final Asset asset;
  final User user;
  const AssetDetails({super.key, required this.asset, required this.user});

  @override
  State<AssetDetails> createState() => _AssetDetailsState();
}

class _AssetDetailsState extends State<AssetDetails> {
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 181, 212),
      appBar: AppBar(title: const Text("Asset Details")),
      body: Column(children: [
        Card(
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
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          widget.asset.productName.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: screenWidth - 16,
          child: Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.none, width: 5),
              columnWidths: const {
                0: FixedColumnWidth(70),
                1: FixedColumnWidth(230),
              },
              children: [
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Description',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.asset.productDesc.toString(),
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Price/unit',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("RM ${widget.asset.productPrice}/unit",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Quantity',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.asset.productQty}(unit)",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Type',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.asset.productType}",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
                TableRow(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Product Id',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.asset.productId}",
                            style: const TextStyle(fontSize: 17.0))
                      ]),
                ]),
              ]),
        ),
        const SizedBox(height: 16),
        
      ]
    )
    );
  }
}