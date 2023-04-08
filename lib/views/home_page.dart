import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../widgets/bottom_nav_bar.dart';
import 'favorites_page.dart';
import 'filter_page.dart';
import 'history_page.dart';
import 'recipes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [Colors.red, Colors.orange, Colors.green];
    List<Widget> pages = const [FavoritesPage(), RecipesPage(), HistoryPage()];
    double x(int index) => (index - _page) * MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: ColorUtils.generateShades(colors[_page]),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: Stack(
              children: List.generate(pages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(x(index), 0, 0),
                  child: pages[index],
                );
              }),
            ),
          ),
          BottomTabBar(
            backgroundColor: colors[_page],
            onPageChanged: (page) => setState(() => _page = page),
          ),
          const FilterPage(),
        ],
      ),
    );
  }
}
