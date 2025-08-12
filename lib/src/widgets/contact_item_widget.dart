import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/data/model/user/user_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
<<<<<<< HEAD

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
=======
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

  bool? contactScreen = false;

  ContactItemWidget(
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
      {super.key,
      this.contactData,
      this.userData,
      this.onTapRow,
      this.onAccepted,
      this.onDeny,
<<<<<<< HEAD
      this.isUser = false,
      this.isContact = false,
      this.contactScreen = false,
      this.onRequest,
      this.addMember});
=======
      this.isUser,
      this.contactScreen,
      this.onRequest});
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7

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
<<<<<<< HEAD
              width: 10.w,
=======
              width: 10.h,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
            ),
            CustomCircleAvatar(
                imagePath: isUser! ? userData!.imagePath! : contactData!.image!,
                size: 40),
            SizedBox(
              width: 10.w,
            ),
            Column(
<<<<<<< HEAD
              crossAxisAlignment: CrossAxisAlignment.start,
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
                  isUser! ? userData!.email! : contactData!.email ?? '',
=======
                  isUser! ? userData!.email! : contactData!.email!,
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
                : _showOptionContact(context, contactData!),
=======
                : _showStatus(context, contactData!),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
            SizedBox(
              width: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _showOptionUser(BuildContext context) {
<<<<<<< HEAD
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
    }
=======
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    return CustomIconButton(
      onTap: onRequest,
      child: Icon(
        Icons.person_add_alt_1_outlined,
        size: 25.sp,
      ),
    );
  }

<<<<<<< HEAD
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
=======
  Widget _showStatus(BuildContext context, ContactData contactData) {
    if (contactData.status == 'REQUESTED' &&
        contactData.userId != PrefUtils().getUser()!.id) {
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        ],
      );
    } else if (contactData.status == 'ACCEPTED' &&
        contactData.userId != PrefUtils().getUser()!.id &&
        contactScreen == true) {
<<<<<<< HEAD
      return CustomIconButton(
        height: 30.h,
        width: 35.w,
        onTap: onDeny,
        child: Icon(
          Icons.close,
          color: Colors.red,
          size: 30.sp,
=======
      return Transform.rotate(
        angle: 50 * 3.1415926535 / 70,
        child: CustomIconButton(
          onTap: onDeny,
          child: Icon(
            Icons.add,
            color: Colors.red,
            size: 30.sp,
          ),
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
        ),
      );
    }
    return const SizedBox();
  }
}
