import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/utils/app_export.dart';

class ContactItemWidget extends StatelessWidget {
  final ContactData? contactData;

  final UserData? userData;

  final VoidCallback? onTapRow;

  final VoidCallback? addMember;

  final VoidCallback? onAccepted;
  final VoidCallback? onDeny;

  final VoidCallback? onRequest;

  final bool? isUser;

  final bool? isContact;

  final bool? contactScreen;

  const ContactItemWidget(
      {super.key,
      this.contactData,
      this.userData,
      this.onTapRow,
      this.onAccepted,
      this.onDeny,
      this.isUser = false,
      this.isContact = false,
      this.contactScreen = false,
      this.onRequest,
      this.addMember});

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
              width: 10.w,
            ),
            CustomCircleAvatar(
                imagePath: isUser! ? userData!.imagePath! : contactData!.image!,
                size: 40),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  isUser! ? userData!.email! : contactData!.email ?? '',
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
                : _showOptionContact(context, contactData!),
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  CustomIconButton _showOptionUser(BuildContext context) {
    if (isContact!) {
      return CustomIconButton(
        height: 30.h,
        width: 35.w,
        onTap: addMember,
        child: Icon(
          Icons.close,
          color: Colors.red,
          size: 30.sp,
        ),
      );
    } else {
      return CustomIconButton(
        height: 30.h,
        width: 35.w,
        onTap: onRequest,
        child: Icon(
          Icons.person_add,
          color: Colors.red,
          size: 30.sp,
        ),
      );
    }
  }

  Widget _showOptionContact(BuildContext context, ContactData contactData) {
    if (PrefUtils().getOptionsContact() == 'REQUESTED' &&
        contactData.status == 'REQUESTED') {
      return CustomIconButton(
        height: 30.h,
        width: 35.w,
        onTap: onDeny,
        child: Icon(
          Icons.close,
          color: Colors.red,
          size: 30.sp,
        ),
      );
    } else if (PrefUtils().getOptionsContact().contains('RECEIVED')) {
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
          CustomIconButton(
            height: 30.h,
            width: 35.w,
            onTap: onDeny,
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 30.sp,
            ),
          )
        ],
      );
    } else if (contactData.status == 'ACCEPTED' &&
        contactData.userId != PrefUtils().getUser()!.id &&
        contactScreen == true) {
      return CustomIconButton(
        height: 30.h,
        width: 35.w,
        onTap: onDeny,
        child: Icon(
          Icons.close,
          color: Colors.red,
          size: 30.sp,
        ),
      );
    }
    return const SizedBox();
  }
}
