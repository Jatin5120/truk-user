import 'package:trukapp/models/quote_model.dart';
import 'package:trukapp/models/user_model.dart';

class ChattingListModel {
  String id;
  UserModel userModel;
  QuoteModel quoteModel;
  int time;
  ChattingListModel({this.id, this.userModel, this.quoteModel, this.time});
}
