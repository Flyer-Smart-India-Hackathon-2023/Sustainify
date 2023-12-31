import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:sustainify/screens/login_screen.dart';
import 'package:sustainify/screens/splash_screen.dart';
import 'bindings/initial_bindings.dart';
import 'controllers/screen_controller.dart';
import 'screens/awareness_screen.dart';
import 'screens/best_from_waste_screen.dart';
import 'screens/display_picture_screen.dart';
import 'screens/map_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/trash_scan_screen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sustainify',
        initialBinding: InitialBindings(),
        initialRoute: "/splash",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 150, 75, 0)),
        ),
        routes: {
          '/home': (context) => MyHomePage(),
          '/splash': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
        });
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
  ScreenController screenController = Get.find<ScreenController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 243, 243),
        body: Stack(children: [
          Padding(
            padding: EdgeInsets.only(top: 30, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                      onPressed: () {
                        if (screenController.screen_index.value != 5) {
                          screenController.prev = screenController.screen_index.value;
                          print(screenController.prev);
                          screenController.screen_index.value = 5;
                        } else {
                          print(screenController.prev);
                          screenController.screen_index.value = screenController.prev;
                        }
                      },
                      icon: Icon(
                        screenController.screen_index.value == 5 ? Icons.notifications_on : Icons.notifications,
                        color: screenController.screen_index.value == 5
                            ? Color.fromARGB(1, 150, 75, 0)
                            : Color.fromARGB(255, 69, 71, 69),
                      )),
                ),
              ],
            ),
          ),
          screenController.screen_index.value == 0
              ? AwarenessScreen()
              : screenController.screen_index.value == 1
                  ? BestFromWasteScreen()
                  : screenController.screen_index.value == 2
                      ? MapScreen()
                      : screenController.screen_index.value == 3
                          ? ProfileScreen()
                          : screenController.screen_index.value == 4
                              ? ScanProductScreen()
                              : NotificationScreen(),
        ]),
        floatingActionButton: FloatingActionButton(
          child: screenController.screen_index.value == 4
              ? Icon(
                  Icons.camera_rounded,
                  color: Colors.white,
                )
              : Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                ),
          onPressed: () async {
            print("help");
            if (screenController.screen_index.value == 4) {
              print("index 4 help");
              screenController.pic = await screenController.cameraController.value.takePicture();
              Get.to(DisplayPicture());
            }
            screenController.screen_index.value = 4;
          },
          backgroundColor: Color.fromARGB(255, 150, 75, 0),
          //paramsd
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [Icons.newspaper, Icons.recycling_rounded, Icons.location_on, Icons.person_2_rounded],
          activeIndex: screenController.screen_index.value,
          activeColor: Color.fromARGB(255, 150, 75, 0),
          inactiveColor: Color.fromARGB(255, 69, 71, 69),
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.smoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => {screenController.screen_index.value = index},
        ),
      ),
    );
  }
}
