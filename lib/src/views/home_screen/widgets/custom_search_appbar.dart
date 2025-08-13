import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/api/api.dart';

class CustomSearchAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool showSearch;
  final Function(bool) onToggleSearch;
  final TextEditingController searchController;
  final PreferredSizeWidget appbar;
  final Function(String) onSearch;

  const CustomSearchAppbar(
      {super.key,
      required this.showSearch,
      required this.onToggleSearch,
      required this.searchController,
      required this.appbar,
      required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return showSearch
        ? AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => onToggleSearch(false),
            ),
            title: TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'lbl_search'.tr(),
                border: InputBorder.none,
              ),
              onChanged: (value) async {
                onSearch(value);
              },
            ),
          )
        : appbar;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
