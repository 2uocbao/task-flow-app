import 'package:easy_localization/easy_localization.dart';
import 'package:logger/logger.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/widgets/custom_text_button.dart';

class DetailAssignDialog extends StatefulWidget {
  const DetailAssignDialog(
      {super.key,
      required this.removeAssign,
      required this.usernameAssigner,
      required this.imageAssigner});

  final VoidCallback removeAssign;
  final String usernameAssigner;
  final String imageAssigner;
  @override
  State<DetailAssignDialog> createState() => _DetailAssignDialogState();
}

class _DetailAssignDialogState extends State<DetailAssignDialog> {
  bool? isRemove = true;

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusStyle.circleBorder5,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Text(
                  'lbl_assignee'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRemove = !isRemove!;
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      ClipOval(
                        child: CustomImageView(
                          height: 40.sp,
                          width: 40.sp,
                          imagePath: widget.imageAssigner,
                          fit: BoxFit.cover,
                          onTap: () {},
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        widget.usernameAssigner,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      isRemove!
                          ? Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomTextButton(
                    text: 'DONE',
                    onPressed: () async {
                      if (!isRemove!) {
                        widget.removeAssign();
                      }
                      NavigatorService.goBack();
                    },
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        )
      ],
    );
  }
}
