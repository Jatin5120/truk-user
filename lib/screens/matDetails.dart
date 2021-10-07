import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/request_model.dart';
import '../models/material_model.dart';
import '../screens/shipmentSummary.dart';
import '../utils/constants.dart';

class MaterialDetails extends StatefulWidget {
  final LatLng source;
  final LatLng destination;
  final RequestModel prevQuote;
  final bool isUpdate;

  const MaterialDetails(
      {Key key,
      this.source,
      this.destination,
      this.prevQuote,
      this.isUpdate = false})
      : super(key: key);

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
  String materialType;
  Locale locale;
  String unitType = "KG";
  LatLng s;
  LatLng d;

  @override
  void initState() {
    super.initState();
    s = widget.source;
    d = widget.destination;
    if (widget.prevQuote != null) {
      RequestModel q = widget.prevQuote;
      materials = q.materials;
      print(q.load);
      trukTypeValue = "openTruk";
      mandateTypeValue = "lease";
      loadTypeValue = "fullTruk";
      pickupDate = q.pickupDate;
      this.s = q.source;
      this.d = q.destination;
    }
  }

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context).locale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.getLocalizationValue(
            locale, LocaleKey.materialDetails)),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: 60,
          width: deviceHeight,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
            ),
            onPressed: () async {
              if (loadTypeValue == null || loadTypeValue.isEmpty) {
                Fluttertoast.showToast(msg: 'Please select load type');
                return;
              }
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

              if (trukTypeValue == null || trukTypeValue.isEmpty) {
                Fluttertoast.showToast(msg: 'Please select truk type');
                return;
              }
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ShipmentSummary(
                    destination: d,
                    source: s,
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
              AppLocalizations.getLocalizationValue(
                  locale,
                  widget.isUpdate
                      ? LocaleKey.update
                      : LocaleKey.continueBooking),
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
                      hint: Text(AppLocalizations.getLocalizationValue(
                          locale, LocaleKey.selectLoadType)),
                      value: loadTypeValue,
                      items: Constants(locale).loadType.map((value) {
                        return DropdownMenuItem<String>(
                          value: value['key'],
                          child: Text(value['value']),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      hint: Text(AppLocalizations.getLocalizationValue(
                          locale, LocaleKey.materialType)),
                      value: materialType,
                      items: materialTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        materialType = _;
                        _materialController.text = _;
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.getLocalizationValue(
                            locale, LocaleKey.requiredText);
                      }
                      return null;
                    },
                    controller: _materialController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.getLocalizationValue(
                          locale, LocaleKey.materialName),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 5),
                        child: TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.getLocalizationValue(
                                  locale, LocaleKey.requiredText);
                            }
                            if (int.parse(value) <= 0) {
                              return '*Invalid';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.getLocalizationValue(
                                locale, LocaleKey.quantity),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        padding: const EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        child: DropdownButton<String>(
                          underline: Container(),
                          value: unitType,
                          onChanged: (string) {
                            setState(() => unitType = string);
                            print(unitType);
                          },
                          items: ["KG", "Tons"].map((e) {
                            return DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    AppLocalizations.getLocalizationValue(
                        locale, LocaleKey.loadDimensions),
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
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return '*Required';
                            //   }
                            //   if (int.parse(value) <= 0) {
                            //     return '*Invalid';
                            //   }
                            //   return null;
                            // },
                            controller: _lengthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.getLocalizationValue(
                                  locale, LocaleKey.length),
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
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return '*Required';
                            //   }
                            //   if (int.parse(value) <= 0) {
                            //     return '*Invalid';
                            //   }
                            //   return null;
                            // },
                            controller: _widthController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.getLocalizationValue(
                                  locale, LocaleKey.width),
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
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return AppLocalizations.getLocalizationValue(locale, LocaleKey.requiredText);
                            //   }
                            //   if (int.parse(value) <= 0) {
                            //     return '*Invalid';
                            //   }
                            //   return null;
                            // },
                            keyboardType: TextInputType.number,
                            controller: _heightController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.getLocalizationValue(
                                  locale, LocaleKey.height),
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
                        if (materialType == null) {
                          Fluttertoast.showToast(
                              msg: AppLocalizations.getLocalizationValue(
                                  locale, LocaleKey.materialType));
                          return;
                        }
                        String materialName = _materialController.text.trim();
                        double quantity =
                            double.parse(_quantityController.text.trim());
                        double length = _lengthController.text.trim().isEmpty
                            ? 0.0
                            : double.parse(_lengthController.text.trim());
                        double width = _widthController.text.trim().isEmpty
                            ? 0.0
                            : double.parse(_widthController.text.trim());
                        double height = _heightController.text.trim().isEmpty
                            ? 0.0
                            : double.parse(_heightController.text.trim());
                        MaterialModel model = MaterialModel(
                          height: height,
                          length: length,
                          materialName: materialName,
                          quantity:
                              unitType == 'Tons' ? quantity * 1000 : quantity,
                          width: width,
                          materialType: materialType,
                          unit: unitType,
                        );
                        materials.add(model);
                        FocusScope.of(context).unfocus();
                        materialType = null;
                        setState(() {});
                      }
                    },
                    child: Text(
                      "+ ${AppLocalizations.getLocalizationValue(locale, LocaleKey.addMaterial)}",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 8),
                  child: Text(
                    AppLocalizations.getLocalizationValue(
                        locale, LocaleKey.yourMaterial),
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
                    AppLocalizations.getLocalizationValue(
                        locale, LocaleKey.pickupDate),
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        onChanged: (date) {
                          print('change $date');
                        },
                        onConfirm: (date) {
                          DateFormat formatter =
                              DateFormat("dd/MM/yyyy hh:mm aa");
                          pickupDate = formatter.format(date);
                          _pickupDateController.text = pickupDate;
                          //print(date);
                          // DatePicker.showTime12hPicker(
                          //   context,
                          //   currentTime: DateTime.now(),
                          //   onConfirm: (time) {
                          //     //formatter = DateFormat()
                          //     _pickupDateController.text = "$pickupDate ${time.hour}:${time.minute}";
                          //     setState(() {});
                          //   },
                          // );
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
                      hint: Text(AppLocalizations.getLocalizationValue(
                          locale, LocaleKey.selectMandateType)),
                      value: mandateTypeValue,
                      items: Constants(locale).mandateType.map((value) {
                        return DropdownMenuItem<String>(
                          value: value['key'],
                          child: Text(value['value']),
                        );
                      }).toList(),
                      onChanged: (_) {
                        FocusScope.of(context).unfocus();
                        mandateTypeValue = _;
                        print(_);
                        setState(() {});
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      hint: Text(AppLocalizations.getLocalizationValue(
                          locale, LocaleKey.selectTrukType)),
                      value: trukTypeValue,
                      items: Constants(locale).trukType.map((value) {
                        return DropdownMenuItem<String>(
                          value: value['key'],
                          child: Text(value['value']),
                        );
                      }).toList(),
                      onChanged: (_) {
                        FocusScope.of(context).unfocus();
                        trukTypeValue = _;
                        print(_);
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
            child: Text(AppLocalizations.getLocalizationValue(
                locale, LocaleKey.noMaterial)),
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
                              style: TextStyle(
                                  fontFamily: "Forte",
                                  fontSize: 25,
                                  color: Colors.white),
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
