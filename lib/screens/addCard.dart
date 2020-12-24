import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import '../utils/constants.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cardHolderNameController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _expiryDate = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget textField({String labelText, TextEditingController controller}) {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          controller: controller,
          onChanged: (st) {},
          decoration: InputDecoration(
              labelText: labelText, border: OutlineInputBorder()),
        ));
  }

  bool isCvvFocused = true;
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      _cardNumberController.text = creditCardModel.cardNumber;
      _expiryDate.text = creditCardModel.expiryDate;
      _cardHolderNameController.text = creditCardModel.cardHolderName;
      _cvvController.text = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Card'),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => Form(
          key: _formKey,
          child: Container(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: CreditCardWidget(
                          cardHolderName: _cardHolderNameController.text,
                          cardNumber: _cardNumberController.text,
                          expiryDate: _expiryDate.text,
                          cvvCode: _cvvController.text,
                          showBackView: false,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 0,
                        child: CreditCardForm(
                          cardHolderName: _cardHolderNameController.text,
                          cardNumber: _cardNumberController.text,
                          cvvCode: _cvvController.text,
                          expiryDate: _expiryDate.text,
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: 65,
                        width: width,
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: RaisedButton(
                          color: primaryColor,
                          onPressed: () {},
                          child: Text(
                            'Add Card',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      // textField(
                      //     labelText: 'Card Number',
                      //     controller: _cardNumberController),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // textField(
                      //     labelText: 'Card Holder Name',
                      //     controller: _cardHolderNameController),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Expanded(
                      //           child: textField(
                      //               labelText: 'Expiry', controller: _expiryDate)),
                      //       Expanded(
                      //         child: Column(
                      //           children: [
                      //             textField(
                      //                 labelText: 'CVV', controller: _cvvController),
                      //             Container(
                      //                 padding: EdgeInsets.only(top: 5),
                      //                 child: Text('(Last 3 Digits on back)'))
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
