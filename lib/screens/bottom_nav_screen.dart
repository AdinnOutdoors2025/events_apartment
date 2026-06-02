/*
import 'package:apartment_project/screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/bottom_nav_viewmodel.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import 'apartment_screen.dart';
import 'kanban_board_screen.dart';

class BottomNavScreen extends ConsumerWidget {
  BottomNavScreen({super.key});

  final List<Widget> pages = [
    const DashboardScreen(),
    ApartmentScreen(),
    KanbanBoardScreen(),
    UploadScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bottomNavProvider);
    final viewModel = ref.read(bottomNavProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        final shouldExit = viewModel.handleBack();

        if (shouldExit) {
          Navigator.maybePop(context);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: state.currentIndex,
          children: pages,
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) => viewModel.changeIndex(index, ref),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.red,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.grey.shade700,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description_outlined),
                activeIcon: Icon(Icons.description),
                label: "Rate Card",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: "Orders",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.upload_outlined),
                activeIcon: Icon(Icons.upload),
                label: "Upload",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                activeIcon: Icon(Icons.more_horiz),
                label: "More",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("DashBoard")),
    );
  }
}

class RateCardScreen extends StatelessWidget {
  const RateCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("RateCard")),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await StorageService.clearToken();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

*/
import 'package:apartment_project/screens/upload_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../login_page.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import '../viewmodel/bottom_nav_viewmodel.dart';
import 'apartment_screen.dart';
import 'kanban_board_screen.dart';

class BottomNavScreen extends ConsumerStatefulWidget {
  const BottomNavScreen({super.key});

  @override
  ConsumerState<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends ConsumerState<BottomNavScreen> {
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      _buildTabNavigator(0, const DashboardScreen()),
      _buildTabNavigator(1, ApartmentScreen()),
      _buildTabNavigator(2, KanbanBoardScreen()),
      _buildTabNavigator(3, UploadScreen()),
      _buildTabNavigator(4, const MoreScreen()),
    ];
  }

  Widget _buildTabNavigator(int index, Widget child) {
    return Navigator(
      key: navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (_) => child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bottomNavProvider);
    final viewModel = ref.read(bottomNavProvider.notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final currentNavigator = navigatorKeys[state.currentIndex].currentState;

        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
          return;
        }

        final shouldExit = viewModel.handleBack();

        if (shouldExit) {
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        body: IndexedStack(index: state.currentIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: state.currentIndex,
          backgroundColor: Colors.white,
          onTap: (index) {
            viewModel.changeIndex(index, ref);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.red,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined),
              activeIcon: Icon(Icons.description),
              label: "Rate Card",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment_outlined),
              activeIcon: Icon(Icons.apartment_sharp),
              label: "Upload",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              activeIcon: Icon(Icons.more_horiz),
              label: "More",
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("DashBoard")),
    );
  }
}

class RateCardScreen extends StatelessWidget {
  const RateCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("RateCard")),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await StorageService.clearToken();
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                }
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
