import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/search_provider.dart';
import '../utils/color_utils.dart';
import '../utils/string_utils.dart';
import '../widgets/bottom_nav_bar.dart';
import 'favorites_page.dart';
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

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    SearchProvider provider = context.watch<SearchProvider>();

    return Stack(
      children: [
        if (provider.showFilter)
          GestureDetector(
            onTap: () => provider.showFilter = false,
            child: AnimatedContainer(
              duration: const Duration(seconds: 2),
              color: Colors.black38,
            ),
          ),
        buildWidget(context, provider, width),
      ],
    );
  }

  Positioned buildWidget(
    BuildContext context,
    SearchProvider provider,
    double width,
  ) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom,
      right: 0,
      top: MediaQuery.of(context).padding.top,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          provider.showFilter ? 0 : width * 0.7,
          0,
          0,
        ),
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: buildColumn(provider),
      ),
    );
  }

  Column buildColumn(SearchProvider provider) {
    return Column(
      children: [
        const SizedBox(height: 100),
        const ListTile(
          title: Text('Filters'),
          trailing: Icon(Icons.close),
        ),
        ListTile(
          title: const Text('Health'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(StringUtils.emptyCheck(provider.search.health)),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
        ListTile(
          title: const Text('Dish Type'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(StringUtils.emptyCheck(provider.search.dishType)),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
        ListTile(
          title: const Text('Meal Type'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(StringUtils.emptyCheck(provider.search.mealType)),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => provider.showFilter = false,
              child: const Text('Clear All'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Apply'),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
