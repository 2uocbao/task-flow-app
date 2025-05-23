import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/widgets/custom_circle_avatar.dart';

// ignore: must_be_immutable
class ContactItemWidget extends StatelessWidget {
  ContactData? contactData;

  UserData? userData;

  VoidCallback? onTapRow;

  VoidCallback? onAccepted;
  VoidCallback? onDeny;

  VoidCallback? onRequest;

  bool? isUser = false;

  ContactItemWidget(
      {super.key,
      this.contactData,
      this.userData,
      this.onTapRow,
      this.onAccepted,
      this.onDeny,
      this.isUser,
      this.onRequest});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapRow?.call();
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(
              width: 10.h,
            ),
            CustomCircleAvatar(
                imagePath: isUser! ? userData!.imagePath! : contactData!.image!,
                size: 40),
            SizedBox(
              width: 10.w,
            ),
            Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  isUser!
                      ? userData!.firstName! + userData!.lastName!
                      : contactData!.userName!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  isUser! ? userData!.email! : contactData!.email!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
            const Spacer(),
            isUser!
                ? _showOptionUser(context)
                : _showStatus(context, contactData!),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _showOptionUser(BuildContext context) {
    return CustomIconButton(
      onTap: onRequest,
      child: Icon(
        Icons.person_add_alt_1_outlined,
        size: 25.sp,
      ),
    );
  }

  Widget _showStatus(BuildContext context, ContactData contactData) {
    if (contactData.status == 'REQUESTED' &&
        contactData.userId != PrefUtils().getUser()!.id) {
      return Row(
        children: [
          CustomIconButton(
            onTap: onAccepted,
            child: Icon(
              Icons.done,
              color: Colors.green,
              size: 25.sp,
            ),
          ),
          Transform.rotate(
            angle: 50 * 3.1415926535 / 70,
            child: CustomIconButton(
              onTap: onDeny,
              child: Icon(
                Icons.add,
                color: Colors.red,
                size: 30.sp,
              ),
            ),
          ),
        ],
      );
    } else if (contactData.status == 'REQUESTED') {
      return Transform.rotate(
        angle: 50 * 3.1415926535 / 70,
        child: CustomIconButton(
          onTap: () {
            NavigatorService.goBack();
          },
          child: Icon(
            Icons.add,
            color: Colors.red,
            size: 30.sp,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
