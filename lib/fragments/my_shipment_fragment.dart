import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/models/material_model.dart';
import 'package:trukapp/models/shipment_model.dart';
import 'package:trukapp/screens/trackShipment.dart';
import 'package:trukapp/utils/constants.dart';
import 'package:trukapp/utils/expandable_card_container.dart';
import '../utils/no_data_page.dart';

class MyShipment extends StatefulWidget {
  final Function onAppbarBack;

  const MyShipment({Key key, this.onAppbarBack}) : super(key: key);

  @override
  _MyShipmentState createState() => _MyShipmentState();
}

class _MyShipmentState extends State<MyShipment> {
  final User user = FirebaseAuth.instance.currentUser;
  bool isStatusUpdating = false;
  List<ShipmentModel> filteredList = [];
  bool isFilter = false;
  final _debouncer = Debouncer(milliseconds: 500);
  // var pShips;
  // @override
  // void initState() {
  //   super.initState();

  //   pShips = Provider.of<MyShipments>(context, listen: false);

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final pShips = Provider.of<MyShipments>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Shipments'),
        centerTitle: true,
        leading: InkWell(
          onTap: widget.onAppbarBack,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16),
        child: pShips.isShipLoading
            ? Center(
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ))
            : (pShips.shipments.length <= 0
                ? NoDataPage(
                    text: 'No Shipments',
                  )
                : myList(pShips.shipments)),
      ),
    );
  }

