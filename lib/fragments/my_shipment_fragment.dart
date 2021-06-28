import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/models/shipment_model.dart';
import 'package:trukapp/utils/constants.dart';
import 'package:trukapp/utils/expandable_card_container.dart';
import 'package:trukapp/locale/locale_keys.dart';
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pShips = Provider.of<MyShipments>(context);
    final locale = AppLocalizations.of(context).locale;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.shipments)),
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
                    text: AppLocalizations.getLocalizationValue(locale, LocaleKey.noShipment),
                  )
                : myShipments(pShips.shipments, locale: locale)),
      ),
    );
  }

  Widget myShipments(List<ShipmentModel> shipments, {Locale locale}) {
    List<int> ids = [];
    for (ShipmentModel d in shipments) {
      ids.add(d.bookingId);
    }
    return Column(
      children: [
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
            hintText: AppLocalizations.getLocalizationValue(locale, LocaleKey.searchHint),
            border: OutlineInputBorder(),
            labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.search),
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
              print(model.load);
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
