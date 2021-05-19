import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/helper/request_status.dart';

class CancelBooking {
  final String status;
  final String docId;
  final String collectionName;
  final User user = FirebaseAuth.instance.currentUser;

  CancelBooking({this.status, this.docId, this.collectionName});

  Future<bool> cancelBooking(String reason, {double price = 0.0, String agent, String bookingId}) async {
    CollectionReference reference = FirebaseFirestore.instance.collection("CancelledBooking");
    CollectionReference bookingRef = FirebaseFirestore.instance.collection(collectionName);
    if (status == RequestStatus.pending) {
      //no charges
      await bookingRef.doc(docId).delete();
      return Future.value(true);
    } else if (status == RequestStatus.accepted) {
      //10% max 1000 rs charged
      double cancellationCharges = price * 0.1;

      cancellationCharges = cancellationCharges > 1000 ? 1000 : cancellationCharges;
      await FirebaseHelper().updateWallet(bookingId, cancellationCharges, 0);
      reference.add({
        'bookingId': bookingId,
        'uid': user.uid,
        'cancelledby': "customer",
        'agent': agent,
        'amount': cancellationCharges,
        'reason': reason,
        'time': DateTime.now().millisecondsSinceEpoch,
      });
      await bookingRef.doc(docId).update({'status': 'cancelled'});
    } else if (status == RequestStatus.assigned) {
      //10% max 1000 rs charged
      double cancellationCharges = price * 0.1;

      cancellationCharges = cancellationCharges > 1000 ? 1000 : cancellationCharges;
      await FirebaseHelper().updateWallet(bookingId, cancellationCharges, 0);
      reference.add({
        'bookingId': bookingId,
        'uid': user.uid,
        'cancelledby': "customer",
        'agent': agent,
        'amount': cancellationCharges,
        'time': DateTime.now().millisecondsSinceEpoch,
        'reason': reason,
      });
      await bookingRef.doc(docId).update({'status': 'cancelled'});
    }
    return Future.value(true);
  }
}
