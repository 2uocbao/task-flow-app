import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/notification/notification_data.dart';
import 'package:taskflow/src/theme/custom_button_style.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_bloc.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_event.dart';
import 'package:taskflow/src/views/notification_screen/bloc/notification_state.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationData notificationData;
  const NotificationItemWidget(
    this.notificationData, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return GestureDetector(
          child: Container(
            color: notificationData.status == false
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1)
                : null,
            width: double.maxFinite,
            child: Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                _buildImageAccount(context, notificationData.image ?? ''),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      _customNotifi(context, notificationData),
                      SizedBox(
                        height: 5.h,
                      ),
                      if (notificationData.typeContent == 'CONTACT') ...{
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomTextButton(
                                text: 'bt_accept'.tr(),
                                buttonStyle: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      CustomButtonStyle.getButtonColor(
                                          context, true),
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () {
                                  context.read<NotificationBloc>().add(
                                      AcceptContactEvent(notificationData));
                                }),
                            CustomTextButton(
                              text: 'bt_deny'.tr(),
                              buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor:
                                    CustomButtonStyle.getButtonColor(
                                        context, false),
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {
                                context.read<NotificationBloc>().add(
                                    DenyContactEvent(
                                        notificationData.contentId!,
                                        notificationData.senderId!));
                              },
                              // denyContact,
                            ),
                          ],
                        ),
                      },
                      SizedBox(
                        height: 5.h,
                      ),
                      _buildTimeNotifi(context, notificationData.createdAt),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
              ],
            ),
          ),
          onTap: () async {
            // updateIsRead(notificationData.id!);
            context
                .read<NotificationBloc>()
                .add(UpdateStatusNotifi(notificationData.id!));
            if (notificationData.type == 'TASK' ||
                notificationData.type == 'COMMENT') {
              NavigatorService.pushNamed(AppRoutes.taskDetailScreen,
                  arguments:
                      TaskDetailArguments(taskId: notificationData.contentId));
            } else if (notificationData.type == 'CONTACT') {
              NavigatorService.pushNamed(AppRoutes.contactScreen);
            }
          },
        );
      },
    );
  }

  Widget _buildImageAccount(BuildContext context, String link) {
    return CustomCircleAvatar(imagePath: link, size: 40);
  }

  Widget _customNotifi(
      BuildContext context, NotificationData notificationData) {
    if (notificationData.type == 'TASK') {
      if (notificationData.typeContent == 'NEW_ASSIGN') {
        return _buildTitleNotifi(
          context,
          '${notificationData.senderName} ${'NotifiAddTask'.tr()} ${notificationData.target}',
        );
      } else if (notificationData.typeContent == 'DUEAT') {
        return _buildTitleNotifi(
          context,
          '${notificationData.target} ${'NotifiDueAt'.tr()}',
        );
      } else if (notificationData.typeContent == 'REMOVE_ASSIGN') {
        return _buildTitleNotifi(
          context,
          '${notificationData.senderName} ${'NotifiRemove'.tr()} ${notificationData.target}',
        );
      }
    } else if (notificationData.type == 'COMMENT') {
      return _buildTitleNotifi(
        context,
        '${notificationData.senderName} ${'NotifiComment'.tr()} ${notificationData.target}',
      );
    } else if (notificationData.type == 'CONTACT') {
      if (notificationData.typeContent == 'REQUEST') {
        return _buildTitleNotifi(
          context,
          '${notificationData.senderName} ${'NotifiRequest'.tr()}',
        );
      } else if (notificationData.typeContent == 'CONTACTACEPT') {
        return _buildTitleNotifi(
          context,
          '${notificationData.senderName} ${'NotifiAccepted'.tr()}',
        );
      }
    } else if (notificationData.type == 'TEAM') {
      if (notificationData.typeContent == 'ADD_MEMBER') {
        return _buildTitleNotifi(
          context,
          '${notificationData.senderName} ${'Notifi_Add_Member'.tr()} ${notificationData.target}',
        );
      } else if (notificationData.typeContent == 'REMOVE_MEMBER') {
        return _buildTitleNotifi(
          context,
          '${notificationData.senderName} ${'Notifi_remove_member'.tr()} ${notificationData.target}',
        );
      } else if (notificationData.typeContent == 'LEAVE_MEMBER') {
        return _buildTitleNotifi(
          context,
          '${notificationData.senderName} ${'notifi_leave'.tr()} ${notificationData.target}',
        );
      }
    }
    return _buildTitleNotifi(context, 'no_data_available'.tr());
  }

  Widget _buildTitleNotifi(BuildContext context, String title) {
    return SizedBox(
      child: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildTimeNotifi(BuildContext context, String? time) {
    return SizedBox(
      child: Text(
        formatDateAndTime(date: time!),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
