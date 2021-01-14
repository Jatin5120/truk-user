import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/helper/helper.dart';
import 'package:trukapp/models/material_model.dart';
import 'package:trukapp/models/shipment_model.dart';
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

  Widget myList(List<ShipmentModel> shipList) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        TextFormField(
          onChanged: (string) {
            if (string.trim().length <= 0 || string.isEmpty) {
              setState(() {
                isFilter = false;
                filteredList = [];
              });
            } else {
              setState(() {
                filteredList = shipList
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
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: isFilter ? filteredList.length : shipList.length,
            itemBuilder: (context, index) {
              ShipmentModel model = isFilter ? filteredList[index] : shipList[index];
              String docID = isFilter ? filteredList[index].id : shipList[index].id;

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

// StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection(FirebaseHelper.shipmentCollection)
//               .where('uid', isEqualTo: user.uid)
//               .orderBy('bookingId', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//                 ),
//               );
//             }
//             if (snapshot.hasError || !snapshot.hasData) {
//               return Center(
//                 child: Text('No Data'),
//               );
//             }
//             if (snapshot.data.size <= 0) {
//               return NoDataPage(
//                 text: 'No Shipment',
//               );
//             }
//             return ListView.builder(
//               itemCount: snapshot.data.size,
//               itemBuilder: (context, index) {
//                 ShipmentModel model = ShipmentModel.fromSnapshot(snapshot.data.docs[index]);
//                 String docID = snapshot.data.docs[index].id;

//                 bool isCollapsed = true;
//                 return ExpandableCardContainer(
//                   docID: docID,
//                   model: model,
//                   isCollapsed: isCollapsed,
//                 );
//               },
//             );
//           },
//         )
