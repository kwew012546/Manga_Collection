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
    return Obx(() {
      final isWide = MediaQuery.of(context).size.width >= 600;
      return Scaffold(
        body: Row(
          children: [
            if (isWide) ...[
              NavigationRail(
                selectedIndex: currentIndex.value,
                onDestinationSelected: (index) => currentIndex.value = index,
                selectedIconTheme: IconThemeData(color: Colors.red),
                selectedLabelTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                unselectedIconTheme: IconThemeData(color: Colors.grey),
                unselectedLabelTextStyle: TextStyle(color: Colors.grey),
                backgroundColor: Colors.black,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  NavigationRailDestination(icon: Icon(Icons.history), label: Text("RECENT")),
                  NavigationRailDestination(icon: Icon(Icons.grid_view), label: Text("LIBRARY")),
                ],
              ),
              VerticalDivider(thickness: 1, width: 1, color: Colors.grey[900]),
            ],
            Expanded(child: pages[currentIndex.value]),
          ],
        ),
        bottomNavigationBar: isWide
            ? null
            : BottomNavigationBar(
                currentIndex: currentIndex.value,
                onTap: (index) => currentIndex.value = index,
                selectedItemColor: Colors.red,
                backgroundColor: Colors.black,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.history), label: "RECENT"),
                  BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "LIBRARY"),
                ],
              ),
      );
    });
  }
}