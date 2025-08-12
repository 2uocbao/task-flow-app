import 'package:taskflow/src/data/api/api.dart';
<<<<<<< HEAD
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/model/team_member/member_data.dart';
import 'package:taskflow/src/data/repository/repository.dart';
=======
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/response/response_list.dart';
import 'package:taskflow/src/data/repository/repository.dart';
import 'package:taskflow/src/widgets/contact_item_widget.dart';
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

class AssignCustomField extends StatefulWidget {
  const AssignCustomField({super.key, required this.assignTo});

  final Function(String, String, String) assignTo;

  @override
  State<AssignCustomField> createState() => AssignCustomFieldState();
}

class AssignCustomFieldState extends State<AssignCustomField>
    with TickerProviderStateMixin {
<<<<<<< HEAD
=======
  // focus node object to detect gained or loss on textField
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  OverlayEntry? _overlayEntry;

  GlobalKey globalKey = GlobalKey();

  final LayerLink _layerLink = LayerLink();

<<<<<<< HEAD
  List<MemberData> _searchResults = [];
=======
  List<ContactData> _searchResults = [];
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

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
<<<<<<< HEAD
        _searchResults.clear();
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        _overlayEntry!.remove();
      }
    });
  }

  void reset() async {
    setState(() {
<<<<<<< HEAD
      _searchResults.clear();
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      _focusNode.unfocus();
      _controller.clear();
    });
  }

<<<<<<< HEAD
  Future<List<MemberData>> _fetchUserResult(String value) async {
    try {
      Map<String, dynamic> queryParam = {
        'keyword': value,
        'page': currentPage,
      };
      final response = await _repository
          .searchTeamMember(PrefUtils().getTeamId(), queryParam: queryParam);

      List<MemberData> userData =
          ResponseList.fromJson(response.data, MemberData.fromJson).data!;
=======
  Future<List<ContactData>> _fetchUserResult(String value) async {
    try {
      Map<String, dynamic> queryParam = {
        'keySearch': value,
        'status': 'ACCEPTED',
        'page': currentPage,
      };
      final response = await _repository.searchContact(
        PrefUtils().getUser()!.id!,
        queryParam: queryParam,
      );

      List<ContactData> userData =
          ResponseList.fromJson(response.data, ContactData.fromJson).data!;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      return userData;
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
              height: 80.h,
              constraints: const BoxConstraints(minHeight: 50),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
<<<<<<< HEAD
                  return customDisplayItem(_searchResults[index]);
=======
                  return ContactItemWidget(
                    contactData: _searchResults[index],
                    isUser: false,
                    contactScreen: false,
                    onTapRow: () {
                      widget.assignTo(
                          _searchResults[index].userId!,
                          _searchResults[index].userName!,
                          _searchResults[index].image!);
                    },
                  );
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget customDisplayItem(MemberData memberData) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
        widget.assignTo(memberData.memberId!, memberData.memberName!,
            memberData.memberImage!);
        _searchResults.clear();
      },
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(bottom: 10.h),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadiusStyle.circleBorder10),
          padding:
              EdgeInsets.only(left: 10.w, top: 10.h, right: 10.w, bottom: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCircleAvatar(
                  imagePath: memberData.memberImage!, size: 30.sp),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memberData.memberName!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
