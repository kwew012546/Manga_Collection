import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/comic_controller.dart';
import 'views/home/home_screen.dart';
import 'views/library/library_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ComicController()); 
  runApp(MangaPlusApp());
}

class MangaPlusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
      ),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatelessWidget {
  final List<Widget> pages = [HomeScreen(), LibraryScreen()];
  final currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[currentIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (index) => currentIndex.value = index,
        selectedItemColor: Colors.red,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "RECENT"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "LIBRARY"),
        ],
      )),
    );
  }
}