import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/recipe_provider.dart';
import '../provider/search_provider.dart';
import '../utils/string_utils.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    SearchProvider provider = context.watch<SearchProvider>();
    bool show = provider.showFilter;

    return Stack(
      children: [
        IgnorePointer(
          ignoring: !show,
          child: GestureDetector(
            onTap: () => provider.showFilter = false,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: show ? Colors.black38 : Colors.transparent,
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.translationValues(show ? 0 : width, 0, 0),
            width: width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const ClipRect(
              clipBehavior: Clip.antiAlias,
              child: FilterView(),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterView extends StatefulWidget {
  const FilterView({Key? key}) : super(key: key);

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  String health = '', dishType = '', mealType = '';
  int _page = 0;

  @override
  void initState() {
    super.initState();
    SearchProvider provider = context.read<SearchProvider>();
    health = provider.health;
    dishType = provider.dishType;
    mealType = provider.mealType;
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider provider = context.watch<SearchProvider>();
    const Duration duration = Duration(milliseconds: 200);
    return Stack(
      children: [
        IgnorePointer(
          ignoring: _page != 0,
          child: AnimatedOpacity(
            duration: duration,
            opacity: _page == 0 ? 1 : 0,
            child: AnimatedContainer(
              duration: duration,
              transform: Matrix4.translationValues(_page == 0 ? 0 : -100, 0, 0),
              child: buildHome(provider),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: _page != 1,
          child: AnimatedOpacity(
            duration: duration,
            opacity: _page == 1 ? 1 : 0,
            child: AnimatedContainer(
              duration: duration,
              transform: Matrix4.translationValues(_page == 1 ? 0 : 100, 0, 0),
              child: buildList(
                provider,
                title: 'Health',
                clear: () => setState(() {
                  health = 'All';
                  _page = 0;
                }),
                list: provider.healthLabels,
                onTap: (label) => setState(() => health = label),
                selected: health,
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: _page != 2,
          child: AnimatedOpacity(
            duration: duration,
            opacity: _page == 2 ? 1 : 0,
            child: AnimatedContainer(
              duration: duration,
              transform: Matrix4.translationValues(_page == 2 ? 0 : 100, 0, 0),
              child: buildList(
                provider,
                title: 'Dish Type',
                clear: () => setState(() {
                  dishType = 'All';
                  _page = 0;
                }),
                list: provider.dishTypes,
                onTap: (label) => setState(() => dishType = label),
                selected: dishType,
              ),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: _page != 3,
          child: AnimatedOpacity(
            duration: duration,
            opacity: _page == 3 ? 1 : 0,
            child: AnimatedContainer(
              duration: duration,
              transform: Matrix4.translationValues(_page == 3 ? 0 : 100, 0, 0),
              child: buildList(
                provider,
                title: 'Meal Type',
                clear: () => setState(() {
                  mealType = 'All';
                  _page = 0;
                }),
                list: provider.mealTypes,
                onTap: (label) => setState(() => mealType = label),
                selected: mealType,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column buildHome(SearchProvider provider) {
    bool hasChanged = health != provider.health ||
        dishType != provider.dishType ||
        mealType != provider.mealType;
    bool hasFilter = health != 'All' || dishType != 'All' || mealType != 'All';

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
            color: Colors.orange,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: ListTile(
              leading: IconButton(
                color: Colors.black54,
                onPressed: () {
                  setState(() {
                    health = provider.health;
                    dishType = provider.dishType;
                    mealType = provider.mealType;
                  });
                  provider.closeFilter();
                },
                icon: const Icon(FontAwesomeIcons.xmark),
              ),
              title: const Text('Filter'),
              trailing: OutlinedButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                onPressed: hasFilter ? clearFilters : null,
                child: const Text('Clear All'),
              ),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          onTap: () => setState(() => _page = 1),
          leading: const Icon(FontAwesomeIcons.solidHeart, color: Colors.red),
          title: const Text('Health'),
          subtitle: Text(StringUtils.capitalize(health)),
          trailing: const Icon(FontAwesomeIcons.chevronRight),
        ),
        const Divider(),
        ListTile(
          onTap: () => setState(() => _page = 2),
          leading: const Icon(FontAwesomeIcons.utensils, color: Colors.orange),
          title: const Text('Dish Type'),
          subtitle: Text(StringUtils.capitalize(dishType)),
          trailing: const Icon(FontAwesomeIcons.chevronRight),
        ),
        const Divider(),
        ListTile(
          onTap: () => setState(() => _page = 3),
          leading: const Icon(FontAwesomeIcons.solidClock, color: Colors.green),
          title: const Text('Meal Type'),
          subtitle: Text(StringUtils.capitalize(mealType)),
          trailing: const Icon(FontAwesomeIcons.chevronRight),
        ),
        const Divider(),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: hasChanged ? () => applyFilter(provider) : null,
              child: const Text('Apply Filters'),
            ),
          ),
        ),
      ],
    );
  }

  void clearFilters() {
    setState(() {
      health = 'All';
      dishType = 'All';
      mealType = 'All';
    });
  }

  void applyFilter(SearchProvider provider) {
    provider.health = health;
    provider.dishType = dishType;
    provider.mealType = mealType;
    provider.closeFilter();
    provider.addSearch();
    context.read<RecipeProvider>().getRecipes(provider.search);
  }

  Column buildList(
    SearchProvider provider, {
    required String title,
    required VoidCallback clear,
    required List<String> list,
    required void Function(String) onTap,
    required String selected,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
            color: Colors.orange,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: ListTile(
              leading: IconButton(
                color: Colors.black54,
                onPressed: () => setState(() => _page = 0),
                icon: const Icon(FontAwesomeIcons.arrowLeft),
              ),
              title: Text(title),
              trailing: OutlinedButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                onPressed: selected == 'All' ? null : clear,
                child: const Text('Clear'),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              String item = list[index];
              return ListTile(
                onTap: () => onTap(item),
                title: Text(StringUtils.capitalize(item)),
                iconColor: item == selected ? Colors.orange : Colors.grey,
                trailing: Icon(
                  item == selected
                      ? FontAwesomeIcons.circleCheck
                      : FontAwesomeIcons.circle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
