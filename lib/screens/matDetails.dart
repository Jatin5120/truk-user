import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trukapp/models/material_model.dart';
import 'package:trukapp/screens/shipmentSummary.dart';
import 'package:trukapp/utils/constants.dart';

class MaterialDetails extends StatefulWidget {
  final LatLng source;
  final LatLng destination;

  const MaterialDetails({Key key, this.source, this.destination}) : super(key: key);

  @override
  _MaterialDetailsState createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<MaterialDetails> {
  double get deviceWidth => MediaQuery.of(context).size.width;
  double get deviceHeight => MediaQuery.of(context).size.height;
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _pickupDateController = TextEditingController();
  String pickupDate;
  List<MaterialModel> materials = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String trukTypeValue, mandateTypeValue, loadTypeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Material Details'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: 60,
          width: deviceHeight,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: RaisedButton(
            color: primaryColor,
            onPressed: () async {
              if (materials.length <= 0) {
                Fluttertoast.showToast(msg: 'Please add your material');
                return;
              }
              if (pickupDate == null || pickupDate.isEmpty) {
                Fluttertoast.showToast(msg: 'Please enter pickup date');
                return;
              }
              if (mandateTypeValue == null || mandateTypeValue.isEmpty) {
                Fluttertoast.showToast(msg: 'Please select mandate type');
                return;
              }
              if (loadTypeValue == null || loadTypeValue.isEmpty) {
                Fluttertoast.showToast(msg: 'Please select load type');
                return;
              }
              if (trukTypeValue == null || trukTypeValue.isEmpty) {
                Fluttertoast.showToast(msg: 'Please select truk type');
                return;
              }
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ShipmentSummary(
                    destination: widget.destination,
                    source: widget.source,
                    loadType: loadTypeValue,
                    mandateType: mandateTypeValue,
                    materials: materials,
                    pickupDate: pickupDate,
                    trukType: trukTypeValue,
                  ),
                ),
              );
            },
            child: Text(
              'Continue Booking',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
      body: Container(
        height: deviceHeight,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '*Required';
                      }
                      return null;
                    },
                    controller: _materialController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Material',
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '*Required';
                      }
                      if (int.parse(value) <= 0) {
                        return '*Invalid';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Quantity',
                      suffix: Text("KG"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Load Dimensions (Cm)',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 60,
                  width: deviceWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '*Required';
                              }
                              if (int.parse(value) <= 0) {
                                return '*Invalid';
                              }
                              return null;
                            },
                            controller: _lengthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: 'Length', border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '*Required';
                              }
                              if (int.parse(value) <= 0) {
                                return '*Invalid';
                              }
                              return null;
                            },
                            controller: _widthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Width',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return '*Required';
                              }
                              if (int.parse(value) <= 0) {
                                return '*Invalid';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: _heightController,
                            decoration: InputDecoration(
                              labelText: 'Height',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        String materialName = _materialController.text.trim();
                        double quantity = double.parse(_quantityController.text.trim());
                        double length = double.parse(_lengthController.text.trim());
                        double width = double.parse(_widthController.text.trim());
                        double height = double.parse(_heightController.text.trim());
                        MaterialModel model = MaterialModel(
                          height: height,
                          length: length,
                          materialName: materialName,
                          quantity: quantity,
                          width: width,
                        );
                        materials.add(model);
                        setState(() {});
                      }
                    },
                    child: Text(
                      '+ Add Material',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
                  child: Text(
                    'Your Materials',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: deviceWidth,
                  height: 100,
                  child: buildMaterialCart(),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
                  child: Text(
                    'Pickup Date',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                    onTap: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          DateFormat formatter = DateFormat("dd/MM/yyyy");
                          pickupDate = formatter.format(date);
                          _pickupDateController.text = pickupDate;
                          setState(() {});
                        },
                        currentTime: DateTime.now(),
                      );
                    },
                    child: Container(
                      height: 50,
                      child: IgnorePointer(
                        ignoring: true,
                        child: TextField(
                          readOnly: true,
                          controller: _pickupDateController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'DD/MM/YYYY',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      isExpanded: true,
                      hint: Text('Select Mandate Type'),
                      value: mandateTypeValue,
                      items: mandateType.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        mandateTypeValue = _;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      isExpanded: true,
                      hint: Text('Select Load Type'),
                      value: loadTypeValue,
                      items: loadType.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        loadTypeValue = _;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      isExpanded: true,
                      hint: Text('Select Truk Type'),
                      value: trukTypeValue,
                      items: trukType.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        trukTypeValue = _;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMaterialCart() {
    return materials.length <= 0
        ? Center(
            child: Text('No Material Added'),
          )
        : ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: materials.length,
            itemBuilder: (context, index) {
              MaterialModel model = materials[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: primaryColor,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "${model.materialName[0].toUpperCase()}",
                              style: TextStyle(fontFamily: "Forte", fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 60,
                            child: Text(
                              "${model.materialName}",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            materials.remove(model);
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.clear,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
