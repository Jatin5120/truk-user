import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import '../utils/constants.dart';

class DebitCard extends StatefulWidget {
  @override
  _DebitCardState createState() => _DebitCardState();
}

class _DebitCardState extends State<DebitCard> {
  @override
  void initState() {
    super.initState();
    tileValue = true;
  }

  @override
  void dispose() {
    super.dispose();
    _cardHolderNameController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.clear();
    _cvvController.dispose();
  }

  Widget payMoney({String amount}) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: primaryColor),
      child: RaisedButton(
        onPressed: () {},
        child: Text(
          'PAY ₹ $amount',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
    );
  }

  TextEditingController _cardHolderNameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  bool isCvvFocused;
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      _cardNumberController.text = creditCardModel.cardNumber;
      _expiryDateController.text = creditCardModel.expiryDate;
      _cardHolderNameController.text = creditCardModel.cardHolderName;
      _cvvController.text = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  bool tileValue = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsetsGeometry padding = EdgeInsets.only(left: 20, right: 20);
    return Scaffold(
      appBar: AppBar(
        title: Text('Debit Card'),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => Container(
          padding: padding,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 0,
                      child: CreditCardForm(
                        cardHolderName: _cardHolderNameController.text,
                        cardNumber: _cardNumberController.text,
                        cvvCode: _cvvController.text,
                        expiryDate: _expiryDateController.text,
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: CheckboxListTile(
                        title: Text('Save card'),
                        value: tileValue,
                        activeColor: primaryColor,
                        checkColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            tileValue = value;
                          });
                        },
                      ),
                    ),
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      height: 65,
                      width: size.width,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: RaisedButton(
                        color: primaryColor,
                        onPressed: () {},
                        child: Text(
                          'Pay Now',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
