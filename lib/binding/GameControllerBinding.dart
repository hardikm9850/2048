import 'package:get/get.dart';
import 'package:hardik_2048/controller/game_controller.dart';

class ConfigurationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => GameController());
  }

}