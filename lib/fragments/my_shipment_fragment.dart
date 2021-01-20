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
                : myShipments(pShips.shipments)),
      ),
    );
  }

  Widget myShipments(List<ShipmentModel> shipments) {
    List<int> ids = [];
    for (ShipmentModel d in shipments) {
      ids.add(d.bookingId);
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'My Shipments',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (string) {
            if (string.trim().length <= 0 || string.isEmpty) {
              setState(() {
                isFilter = false;
                filteredList = [];
              });
            } else {
              setState(() {
                filteredList = shipments
                    .where((element) =>
                        element.bookingId.toString().contains(string.trim().toLowerCase()) ||
                        element.price.contains(string.toLowerCase()) ||
                        element.pickupDate.contains(string.toLowerCase()))
                    .toList();
                isFilter = true;
              });
            }
          },
          decoration: InputDecoration(
            hintText: 'Type Order Id, pickup date, fare...',
            border: OutlineInputBorder(),
            labelText: 'Search',
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: isFilter ? filteredList.length : shipments.length,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ShipmentModel model = isFilter ? filteredList[index] : shipments[index];
              String docID = isFilter ? filteredList[index].id : shipments[index].id;

              bool isCollapsed = true;
              return ExpandableCardContainer(
                docID: docID,
                model: model,
                isCollapsed: isCollapsed,
              );
            },
          ),
        ),
      ],
    );
  }
}
