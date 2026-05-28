import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxController {
  static ConnectivityService get to => Get.find();
  
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _listenToConnectivityChanges();
  }
  
  Future<void> _checkConnectivity() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }
  
  void _listenToConnectivityChanges() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      isConnected.value = false;
    } else {
      isConnected.value = true;
    }
  }
  
  bool get hasInternet => isConnected.value;
}
