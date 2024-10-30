import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/home_view_model.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  // final homeViewController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    // homeViewController.getAllProduct();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('home screen')),

    );
  }
}
