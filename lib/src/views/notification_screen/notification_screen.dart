import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/notification/notification_data.dart';
import 'package:taskflow/src/theme/custom_button_style.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_bloc.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_event.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_state.dart';
import 'package:taskflow/src/views/notification_screen/model/notification_model.dart';
import 'package:taskflow/src/views/notification_screen/widgets/notification_item_widget.dart';
import 'package:taskflow/src/widgets/custom_text_button.dart';
import 'package:taskflow/src/utils/app_export.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      child: const NotificationScreen(),
      create: (context) => NotificationBloc(
        NotificationState(
          notificationModel: NotificationModel(),
        ),
      )..add(FetchNotificationEvent()),
    );
  }

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _scrollController = ScrollController();

  void _onScroll() {
    if (_isBottom) {
      context.read<NotificationBloc>().add(FetchNotificationEvent());
    }
  }

  bool get _isBottom {
    if (context.read<NotificationBloc>().state.hasMore) {
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
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildTabView(context),
            Expanded(
              child: _buildNotificationList(context),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 50.h,
      leading: CustomIconButton(
        height: 30.h,
        child: Icon(
          Icons.arrow_back_outlined,
          size: 30.sp,
        ),
        onTap: () {
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
        },
      ),
      centerTitle: true,
      title: Text(
        "lbl_notification".tr(),
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10.w),
          child: CustomIconButton(
            height: 30.h,
            child: Icon(
              Icons.done_all,
              size: 30.sp,
            ),
            onTap: () {
              context.read<NotificationBloc>().add(UpdateStatusAllNotifi());
            },
          ),
        )
      ],
    );
  }

  Widget _buildTabView(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDropSelectType(context),
          _buildStatusButton(context),
        ],
      ),
    );
  }

  Widget _buildDropSelectType(BuildContext context) {
    List<String> trans =
        Utils().notifiOption.map((notifi) => notifi.tr()).toList();
    int index;
    return BlocSelector<NotificationBloc, NotificationState,
        NotificationModel?>(
      selector: (state) => state.notificationModel,
      builder: (context, state) {
        return CustomDropdownButton(
          textStyle: Theme.of(context).textTheme.bodyMedium,
          items: trans,
          value: PrefUtils().getTypeNotifi().tr(),
          onChanged: (value) {
            index = trans.indexOf(value!);
            String? indexValue = Utils().notifiOption[index];
            context
                .read<NotificationBloc>()
                .add(ChangeTypeNotificationEvent(indexValue));
          },
        );
      },
    );
  }

  Widget _buildStatusButton(BuildContext context) {
    return BlocSelector<NotificationBloc, NotificationState,
        NotificationModel?>(
      selector: (state) => state.notificationModel,
      builder: (context, state) {
        state?.selectedStatus = PrefUtils().getReadNotifi();
        return SizedBox(
          child: CustomTextButton(
            text: "bt_unread".tr(),
            buttonTextStyle: Theme.of(context).textTheme.bodyMedium,
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: CustomButtonStyle.getButtonColor(
                  context, state?.selectedStatus == false),
              foregroundColor: Colors.black,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.circleBorder20,
            ),
            onPressed: () {
              bool unread = !(state?.selectedStatus)!;
              context
                  .read<NotificationBloc>()
                  .add(ChangeStatusNotificationEvent(unread));
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationList(BuildContext context) {
    return BlocSelector<NotificationBloc, NotificationState, NotificationModel>(
      selector: (state) => state.notificationModel,
      builder: (context, state) {
        bool has = false;
        String timenow = "TODAY".tr();
        List<NotificationData> listNotifi = state.notificationData;
        List<Widget> notifiWidget = [];
        for (var notifi in listNotifi) {
          String stringTime = time(notifi.createdAt!);
          if (stringTime == timenow) {
            if (!has) {
              notifiWidget.add(
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                  child: Text(
                    timenow,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
              has = true;
            }
          } else {
            timenow = stringTime;
            notifiWidget.add(
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                child: Text(
                  timenow,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
            has = true;
          }
          notifiWidget.add(
            NotificationItemWidget(
              notifi,
              acceptContact: (value) {
                context.read<NotificationBloc>().add(AcceptContactEvent(value));
              },
              denyContact: () {
                context
                    .read<NotificationBloc>()
                    .add(DenyContactEvent(notifi.contentId!, notifi.senderId!));
              },
              updateIsRead: (value) {
                context.read<NotificationBloc>().add(UpdateStatusNotifi(value));
              },
            ),
          );
        }
        return ListView(
          controller: _scrollController,
          children: notifiWidget,
        );
      },
    );
  }
}
