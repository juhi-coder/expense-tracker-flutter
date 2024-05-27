import 'package:expanse_tracker/app/app.router.dart';
import 'package:expanse_tracker/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeViewModel extends BaseViewModel {
  final _apiService = ApiService();
  final _navigationService = NavigationService();
  final _dialogService = DialogService();
  Razorpay? _razorpay;

  List<dynamic> filterUsers = [];
  List<dynamic> users = [];
  void init() {
    getExpenses();
    filterUsers = users;
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    notifyListeners();
  }

  Future<void> postExpenses(
      String name, String category, dynamic amount) async {
    setBusy(true);
    if (await _apiService.postExpenses(name, category, amount)) {
      _navigationService.navigateTo(Routes.expenseView);
    }
    setBusy(false);
  }

  Future<List<dynamic>> getExpenses() async {
    users = await _apiService.getExpenses();
    return users;
  }

  Future<void> updateExpense(
      int id, String name, String category, dynamic amount) async {
    setBusy(true);
    if (await _apiService.updateExpense(id, name, category, amount)) {
      await getExpenses();
      _navigationService.navigateTo(Routes.expenseView);
      notifyListeners();
    }
    setBusy(false);
  }

  Future<void> deleteExpense(int id) async {
    DialogResponse<dynamic>? confirmationResult =
        await _dialogService.showConfirmationDialog(
      title: 'Are you sure want to delete',
      cancelTitle: 'No',
      confirmationTitle: 'Yes',
    );

    if (confirmationResult?.confirmed == true) {
      await _apiService.deleteExpense(id);
      getExpenses();
      notifyListeners();
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'SUCCESS PAYMENT:${response.paymentId}', timeInSecForIosWeb: 6);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'ERROR HERE:${response.code} -${response.message}',
        timeInSecForIosWeb: 6);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'EXTERNAL_WALLET IS :${response.walletName}',
        timeInSecForIosWeb: 6);
  }

  Future<void> makePayment(int amount, String currency, String receipt) async {
    var orderResponse =
        await _apiService.createOrder(amount, currency, receipt);
    try {
      _razorpay?.open({
        'amount': orderResponse['amount'],
        'currency': orderResponse['currency'],
        'receipt': orderResponse['receipt'],
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'ERRORT:${e.toString()}', timeInSecForIosWeb: 6);
    }
  }

  void searchExpenses(String query) {
    if (query.isEmpty) {
      filterUsers = List.from(users);
    } else {
      filterUsers = users.where((expense) {
        final name = expense['name'].toString().toLowerCase();
        final category = expense['category'].toString().toLowerCase();
        return name.contains(query.toLowerCase()) ||
            category.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
