import 'package:flutter/material.dart';
import 'package:get/get.dart';


class getxtest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Example'),
      ),
      body: Center(
        child: Container(
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text('Counter: ${Get.find<CounterController>().count}')),
              ElevatedButton(
                onPressed: () => Get.find<CounterController>().increment(),
                child: Text('Increment'),
              ),
              ElevatedButton(
                onPressed: () => Get.find<CounterController>().decrement(),
                child: Text('Decrement'),
              ),
              ElevatedButton(
                onPressed: () => Get.to(CounterPage()),
                child: Text('Show Counter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: Center(
        child: Obx(() => Text('Counter: ${Get.find<CounterController>().count}')),
      ),
    );
  }
}

class CounterController extends GetxController {
  var count = 0.obs;

  void increment() => count.value++;
  void decrement() => count.value--;
}
