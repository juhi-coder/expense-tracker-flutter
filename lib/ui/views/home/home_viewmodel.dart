import 'package:expanse_tracker/app/app.router.dart';
import 'package:expanse_tracker/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _apiService = ApiService();
  final _navigationService = NavigationService();

  void init() {
    getExpenses();
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
    return await _apiService.getExpenses();
  }

  // Future<void>logout()async{
  //   final response=
  // }
}
