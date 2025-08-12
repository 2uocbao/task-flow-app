import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/bloc/confirm_delete_bloc.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/bloc/confirm_delete_event.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/bloc/confirm_delete_state.dart';
import 'package:taskflow/src/views/confirm_delete_dialog/model/custom_id.dart';
<<<<<<< HEAD
import 'package:taskflow/src/utils/app_export.dart';

=======
import 'package:taskflow/src/widgets/custom_text_button.dart';
import 'package:taskflow/src/utils/app_export.dart';

// ignore: must_be_immutable
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({super.key});

  static Widget builder(BuildContext context, CustomId customId) {
    return BlocProvider<ConfirmDeleteBloc>(
      create: (context) => ConfirmDeleteBloc(
        ConfirmDeleteState(customId: customId),
      ),
      child: const ConfirmDeleteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return BlocSelector<ConfirmDeleteBloc, ConfirmDeleteState, CustomId>(
      selector: (state) => state.customId!,
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusStyle.circleBorder10,
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                children: [
                  Text(
                    state.title!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    state.subTitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomTextButton(
                        width: 100.w,
                        text: 'bt_cancel'.tr(),
                        buttonTextStyle: Theme.of(context).textTheme.bodySmall,
                        onPressed: () {
                          NavigatorService.goBack();
                        },
                      ),
                      CustomTextButton(
                        width: 100.w,
                        text: 'bt_ok'.tr(),
                        buttonTextStyle: Theme.of(context).textTheme.bodySmall,
                        onPressed: () {
                          switch (state.type) {
                            case 'TASK':
                              context
                                  .read<ConfirmDeleteBloc>()
                                  .add(RequestDeleteTaskEvent());
                              break;
                            case 'COMMENT':
                              context
                                  .read<ConfirmDeleteBloc>()
                                  .add(RequestDeleteCommentEvent());
                              break;
                            case 'REPORT':
                              context
                                  .read<ConfirmDeleteBloc>()
                                  .add(RequestDeleteReportEvent());
                              break;
                            case 'MEMBER':
                              context
                                  .read<ConfirmDeleteBloc>()
                                  .add(RequestDeleteMemberEvent());
                              break;
                            case 'TEAM':
                              context
                                  .read<ConfirmDeleteBloc>()
                                  .add(RequestDeleteTeamEvent());
                            default:
                              return;
                          }
                        },
                      )
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
      },
=======
    String? type = context.watch<ConfirmDeleteBloc>().state.customId!.type;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusStyle.circleBorder5,
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                child: Text(
                  "${"lbl_title".tr()}${type!}?",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
                child: Text(
                  "$type${"lbl_subtitle".tr()}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomTextButton(
                    width: 100.w,
                    text: 'bt_cancel'.tr(),
                    buttonTextStyle: Theme.of(context).textTheme.bodySmall,
                    onPressed: () {
                      NavigatorService.goBack();
                    },
                  ),
                  CustomTextButton(
                    width: 100.w,
                    text: 'bt_ok'.tr(),
                    buttonTextStyle: Theme.of(context).textTheme.bodySmall,
                    onPressed: () {
                      if (type == 'Task') {
                        context
                            .read<ConfirmDeleteBloc>()
                            .add(RequestDeleteTaskEvent());
                      } else if (type == 'Comment') {
                        context
                            .read<ConfirmDeleteBloc>()
                            .add(RequestDeleteCommentEvent());
                      } else if (type == 'Report') {
                        context
                            .read<ConfirmDeleteBloc>()
                            .add(RequestDeleteReportEvent());
                      }
                    },
                  )
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        )
      ],
>>>>>>> 171a38493ae278d0d36e52f0fa44f840961665e7
    );
  }
}
