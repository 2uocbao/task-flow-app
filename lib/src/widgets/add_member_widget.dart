import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/widgets/contact_item_widget.dart';

class AddMemberWidget extends StatefulWidget {
  const AddMemberWidget(
      {super.key,
      required this.addMember,
      required this.height,
      required this.teamId});

  final String teamId;

  final Function(ContactData) addMember;

  final double height;

  @override
  State<AddMemberWidget> createState() => AddMemberWidgetState();
}

class AddMemberWidgetState extends State<AddMemberWidget>
    with TickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  OverlayEntry? _overlayEntry;

  GlobalKey globalKey = GlobalKey();

  final LayerLink _layerLink = LayerLink();

  List<ContactData> _searchResults = [];

  int currentPage = 0;

  final _repository = Repository();

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    OverlayState? overlayState = Overlay.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalKey;
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlay();
        overlayState.insert(_overlayEntry!);
      } else {
        _overlayEntry!.remove();
      }
    });
  }

  void reset() async {
    setState(() {
      _focusNode.unfocus();
      _controller.clear();
    });
  }

  Future<List<ContactData>> _fetchUserResult(String value) async {
    try {
      Map<String, dynamic> queryParam = {
        'keyword': value,
        'status': 'ACCEPTED',
        'page': currentPage,
      };
      final response = await _repository.searchForAdd(
        widget.teamId,
        queryParam: queryParam,
      );

      List<ContactData> contactData =
          ResponseList.fromJson(response.data, ContactData.fromJson).data!;
      return contactData;
    } catch (e) {
      return [];
    }
  }

  OverlayEntry _createOverlay() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            child: Container(
              height: widget.height,
              constraints: const BoxConstraints(minHeight: 50),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ContactItemWidget(
                    contactData: _searchResults[index],
                    isUser: false,
                    contactScreen: false,
                    onTapRow: () {
                      widget.addMember(_searchResults[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onChanged(String value) async {
    if (value.isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      return;
    }

    final result = await _fetchUserResult(value);

    setState(() {
      _searchResults = result;
    });

    // Gỡ Overlay cũ nếu có
    _overlayEntry?.remove();

    // Tạo Overlay mới
    _overlayEntry = _createOverlay();

    // ignore: use_build_context_synchronously
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: _focusNode,
        controller: _controller,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        onChanged: _onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
