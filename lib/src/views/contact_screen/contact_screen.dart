import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/contact_screen/bloc/contact_bloc.dart';
import 'package:taskflow/src/views/contact_screen/bloc/contact_event.dart';
import 'package:taskflow/src/views/contact_screen/bloc/contact_state.dart';
<<<<<<< HEAD
=======
import 'package:taskflow/src/views/contact_screen/model/contact_model.dart';
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
import 'package:taskflow/src/views/home_screen/widgets/custom_search_appbar.dart';
import 'package:taskflow/src/widgets/contact_item_widget.dart';

class ConTactScreen extends StatefulWidget {
  const ConTactScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<ContactBloc>(
      create: (context) => ContactBloc(
<<<<<<< HEAD
        const ContactState(),
=======
        ContactState(
          contactModel: ContactModel(),
        ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      )..add(
          FetchContactEvent(),
        ),
      child: const ConTactScreen(),
    );
  }

  @override
  State<ConTactScreen> createState() => _ConTactScreenState();
}

class _ConTactScreenState extends State<ConTactScreen> {
  bool _showSearch = false;
  final TextEditingController _textController = TextEditingController();
  bool _isFetching = false;
  final _scrollController = ScrollController();
<<<<<<< HEAD
  final logger = Logger();

  void _onSearchContact(String keySearch) async {
    if (keySearch.isNotEmpty) {
      if (PrefUtils().getOptionsContact() == 'REQUESTED') {
        context.read<ContactBloc>().add(SearchUserEvent(keySearch));
      } else {
        context.read<ContactBloc>().add(SearchContactEvent(keySearch));
      }
      setState(() {
        _textController.text = keySearch;
      });
    }
=======

  void _onSearchContact(String keySearch) async {
    if (PrefUtils().getOptionsContact() == 'REQUESTED') {
      context.read<ContactBloc>().add(SearchUserEvent(keySearch));
    } else {
      context.read<ContactBloc>().add(SearchContactEvent(keySearch));
    }
    setState(() {
      _textController.text = keySearch;
    });
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  void _resetWhenSearchOf() async {
    _textController.clear();
<<<<<<< HEAD
    _showSearch = false;
    context.read<ContactBloc>().state.copyWith(hasMore: false);
    context.read<ContactBloc>().add(ReloadContactEvent());
=======
    context.read<ContactBloc>().add(FetchContactEvent());
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  void _onScroll() {
    if (_isBottom && !_isFetching) {
      _isFetching = true;
      context.read<ContactBloc>().add(FetchContactEvent());
      Future.delayed(const Duration(seconds: 1), () => _isFetching = false);
    }
    if (_isBottom) {
      context.read<ContactBloc>().add(FetchContactEvent());
    }
  }

  bool get _isBottom {
    if (context.read<ContactBloc>().state.hasMore) {
      return false;
    }
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        if (state is FetchContactFailure) {
          return SafeArea(
            child: Scaffold(
              appBar: _buildAppBar(context),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error),
                  SizedBox(height: 5.h),
                  CustomTextButton(
                    text: 'bt_reload'.tr(),
                    onPressed: () {
                      context.read<ContactBloc>().add(FetchContactEvent());
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return SafeArea(
            child: Scaffold(
          appBar: CustomSearchAppbar(
            showSearch: _showSearch,
            onToggleSearch: (value) => setState(() {
              _resetWhenSearchOf();
            }),
            onSearch: _onSearchContact,
            searchController: _textController,
            appbar: _buildAppBar(context),
          ),
          body: _buildBody(context, state),
        ));
      },
    );
=======
    return BlocSelector<ContactBloc, ContactState, ContactState>(
        selector: (state) => state,
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
            appBar: CustomSearchAppbar(
              showSearch: _showSearch,
              onToggleSearch: (value) => setState(() {
                _showSearch = value;
                _resetWhenSearchOf();
              }),
              onSearch: _onSearchContact,
              searchController: _textController,
              appbar: _buildAppBar(context),
            ),
            body: _buildBody(context, state),
          ));
        });
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () {
              NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              size: 25.sp,
            ),
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _showSearch = true;
            });
          },
          icon: Icon(
            Icons.search,
            size: 25.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ContactState state) {
    List<ContactData> contactData = [];
    List<UserData> userData = [];
    if (_showSearch) {
      if (PrefUtils().getOptionsContact() == 'REQUESTED') {
        userData = state.userResult;
      } else {
        contactData = state.contactResult;
      }
    } else {
<<<<<<< HEAD
      contactData = state.contactData;
    }
    if (contactData.isEmpty && userData.isEmpty) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              !_showSearch
                  ? _buildDropOptionContact(context, state)
                  : const SizedBox(),
              SizedBox(
                width: 30.w,
              ),
            ],
          ),
          SizedBox(
            child: Center(
              child: Text('no_data_available'.tr()),
            ),
          ),
        ],
      );
=======
      contactData = state.contactModel.contactData;
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            !_showSearch
                ? _buildDropOptionContact(context, state)
                : const SizedBox(),
            SizedBox(
              width: 30.w,
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: isUserOrContact() ? userData.length : contactData.length,
            itemBuilder: (context, index) {
              return ContactItemWidget(
                contactData: !isUserOrContact() ? contactData[index] : null,
                isUser: isUserOrContact(),
                contactScreen: true,
                userData: isUserOrContact() ? userData[index] : null,
                onTapRow: () {},
                onAccepted: () {
                  context
                      .read<ContactBloc>()
<<<<<<< HEAD
                      .add(AcceptRequestEvent(contactData[index]));
=======
                      .add(AcceptRequestEvent(contactData[index].id!));
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
                },
                onDeny: () {
                  context
                      .read<ContactBloc>()
                      .add(DenyRequestEvent(contactData[index].id!));
                },
                onRequest: () {
                  context
                      .read<ContactBloc>()
                      .add(SendRequestEvent(userData[index].id!));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropOptionContact(BuildContext context, ContactState state) {
    List<String> trans =
        Utils().typeContacts.map((contact) => contact.tr()).toList();
    int index;
    return CustomDropdownButton(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      width: 160.w,
      items: trans,
      value: PrefUtils().getOptionsContact().tr(),
      onChanged: (value) {
        index = trans.indexOf(value!);
        String? indexValue = Utils().typeContacts[index];
        context.read<ContactBloc>().add(ChangeOptionEvent(indexValue));
      },
    );
  }

  bool isUserOrContact() {
    if (PrefUtils().getOptionsContact() == 'REQUESTED' && _showSearch) {
      return true;
    }
    return false;
  }
}
