import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/search_model.dart';
import '../provider/search_provider.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/dismiss_background.dart';
import '../widgets/empty_row.dart';
import '../widgets/page_title.dart';
import '../widgets/scrollable_box.dart';
import '../widgets/search_row.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ScrollController controller = ScrollController();
  double _offset = 0;
  bool _isEditing = false;
  final List<Search> _selected = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() => _offset = controller.offset));
  }

  @override
  Widget build(BuildContext context) {
    SearchProvider provider = context.watch<SearchProvider>();
    List<Search> history = provider.history;
    return Theme(
      data: ThemeData(primarySwatch: Colors.green),
      child: Column(
        children: [
          PageTitle(
            title: 'Search History',
            subtitle: 'Your search history',
            icon: FontAwesomeIcons.clockRotateLeft,
            trailing: editButton(history),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _offset > 20 ? 1 : 0,
            child: Container(height: 2, color: Colors.green),
          ),
          ScrollableBox(
            color: Colors.green,
            controller: controller,
            offset: _offset,
            top: deleteSelectedButton(),
            bottom: history.isEmpty || _isEditing
                ? null
                : const EmptyRow(
                    hasBackground: true,
                    title: 'Swipe to remove',
                    subtitle: 'Swipe left to remove from favorites',
                    icon: FontAwesomeIcons.arrowLeftLong,
                  ),
            children: [
              if (history.isEmpty)
                const EmptyRow(
                  title: 'No search history',
                  subtitle: 'Search for recipes to add to your history',
                  icon: FontAwesomeIcons.magnifyingGlass,
                ),
              ...history.map((search) {
                return Dismissible(
                  key: ValueKey(search),
                  direction: _isEditing
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  background: const DismissBackground(),
                  onDismissed: (direction) => provider.removeSearch(search),
                  confirmDismiss: (direction) => confirmDismiss(search),
                  child: SearchRow(search: search, trailing: trailing(search)),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget? editButton(List<Search> history) {
    if (history.isEmpty) return null;
    return IconButton(
      icon: const Icon(FontAwesomeIcons.solidPenToSquare),
      onPressed: toggleEdit,
    );
  }

  void toggleEdit() {
    _selected.clear();
    setState(() => _isEditing = !_isEditing);
  }

  Widget deleteSelectedButton() {
    if (!_isEditing) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: deleteAll,
            child: const Text('Delete All'),
          ),
          ElevatedButton(
            onPressed: _selected.isEmpty ? null : deleteSelected,
            child: const Text('Delete Selected'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAll() async {
    bool? response = await showDialog(
      context: context,
      builder: (_) => const ConfirmDialog(
        title: 'Delete all history?',
        content: 'Are you sure you want to delete all your history?',
      ),
    );
    if (response != true) return;
    context.read<SearchProvider>().clearHistory();
    _selected.clear();
    _isEditing = false;
    setState(() {});
  }

  void deleteSelected() {
    SearchProvider provider = context.read<SearchProvider>();
    for (Search search in _selected) {
      provider.removeSearch(search);
    }
    setState(() {
      _isEditing = false;
      _selected.clear();
    });
  }

  Widget? trailing(Search search) {
    if (!_isEditing) return null;
    return Checkbox(
      value: search.isExist(_selected),
      onChanged: (value) {
        if (value ?? false) {
          setState(() => _selected.add(search));
        } else {
          setState(() => _selected.removeAt(search.findIndex(_selected)));
        }
      },
    );
  }

  Future<bool?> confirmDismiss(Search search) async {
    return await showDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'Remove from history?',
        content:
            'Are you sure you want to remove "${search.query}" from your history?',
      ),
    );
  }
}
