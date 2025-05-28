import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/notification/notification_data.dart';
import 'package:taskflow/src/theme/custom_button_style.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/views/task_detail_screen/models/task_detail_arguments.dart';
import 'package:taskflow/src/widgets/custom_circle_avatar.dart';
import 'package:taskflow/src/widgets/custom_text_button.dart';

// ignore: must_be_immutable
class NotificationItemWidget extends StatelessWidget {
  NotificationData notificationData;
  Function(String) acceptContact;
  VoidCallback? denyContact;
  Function(String) updateIsRead;
  NotificationItemWidget(this.notificationData,
      {super.key,
      required this.acceptContact,
      this.denyContact,
      required this.updateIsRead});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        color: notificationData.status == false
            ? Theme.of(context).colorScheme.onSurface.withOpacity(0.1)
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
                  _buildTitleNotifi(context, notificationData),
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
                                CustomButtonStyle.getButtonColor(context, true),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: acceptContact(notificationData.contentId!),
                        ),
                        CustomTextButton(
                          text: 'bt_deny'.tr(),
                          buttonStyle: ElevatedButton.styleFrom(
                            backgroundColor: CustomButtonStyle.getButtonColor(
                                context, false),
                            foregroundColor: Colors.black,
                          ),
                          onPressed: denyContact,
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
        updateIsRead(notificationData.id!);
        if (notificationData.type == 'TASK' ||
            notificationData.type == 'COMMENT') {
          NavigatorService.pushNamed(AppRoutes.taskDetailScreen,
              arguments:
                  TaskDetailArguments(taskId: notificationData.contentId));
        }
      },
    );
  }

  Widget _buildImageAccount(BuildContext context, String link) {
    return CustomCircleAvatar(imagePath: link, size: 40);
  }

  Widget _buildTitleNotifi(
      BuildContext context, NotificationData notificationData) {
    String title;
    if (notificationData.type == 'TASK') {
      if (notificationData.typeContent == 'NEW_ASSIGN') {
        title =
            '${notificationData.senderName} ${'NotifiAddTask'.tr()} ${notificationData.titleTask}';
      } else {
        title =
            '${notificationData.senderName} ${'NotifiRemove'.tr()} ${notificationData.titleTask}';
      }
    } else if (notificationData.type == 'COMMENT') {
      title =
          '${notificationData.senderName} ${'NotifiComment'.tr()} ${notificationData.titleTask}';
    } else if (notificationData.type == 'CONTACT') {
      title = '${notificationData.senderName} ${'NotifiRequest'.tr()}';
    } else {
      title = '${'NotifiDueAt'.tr()} ${notificationData.titleTask}';
    }
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
