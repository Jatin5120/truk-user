import 'package:flutter/material.dart';

class MaterialDetails extends StatefulWidget {
  @override
  _MaterialDetailsState createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<MaterialDetails> {
  double get deviceWidth => MediaQuery.of(context).size.width;
  double get deviceHeight => MediaQuery.of(context).size.height;
  TextEditingController length = TextEditingController();
  TextEditingController width = TextEditingController();
  TextEditingController height = TextEditingController();
  GlobalKey<FormState> lengthKey = GlobalKey<FormState>();
  GlobalKey<FormState> widthKey = GlobalKey<FormState>();
  GlobalKey<FormState> heightKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Details'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            height: deviceHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Material'),
                      items: [],
                      onChanged: (value) {}),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Quantity'),
                      items: [],
                      onChanged: (value) {}),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Load Dimensions (Cm)',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: deviceWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Form(
                            key: lengthKey,
                            child: TextFormField(
                              controller: length,
                              decoration: InputDecoration(
                                  hintText: 'Length',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Form(
                            key: widthKey,
                            child: TextFormField(
                              controller: width,
                              decoration: InputDecoration(
                                  hintText: 'Width',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Form(
                            key: heightKey,
                            child: TextFormField(
                              controller: height,
                              decoration: InputDecoration(
                                  hintText: 'Height',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      '+ Add Material',
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: InputDatePickerFormField(
                      firstDate: DateTime(1990, 1, 1, 0, 0),
                      lastDate: DateTime.now()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
