import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/validation_functions.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_bloc.dart';
import 'package:taskflow/src/views/task_detail_screen/bloc/task_detail_event.dart';
class ReportUrlDialog extends StatelessWidget {
  ReportUrlDialog(this.addUrl, {super.key});

  final Function(String) addUrl;

  late final TextEditingController _controllerUrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context, Function(String) addUrl) {
    return ReportUrlDialog(
      addUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.circleBorder5,
            ),
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Text('attachLink'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  child: CustomTextFormField(
                    width: 200.w,
                    hintText: 'Url',
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    controller: _controllerUrl,
                    onChange: (value) {
                      _controllerUrl.text = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "err_please_enter_valid_url".tr();
                      } else {
                        isUrl(Uri.parse(value)).then((onValue) async {
                          if (onValue == false) {
                            return "err_please_enter_valid_url".tr();
                          }
                        });
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomTextButton(
                      text: 'bt_cancel'.tr(),
                      onPressed: () async {
                        NavigatorService.goBack();
                      },
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    CustomTextButton(
                      text: 'Done',
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<TaskDetailBloc>().add(
                              AttachmentsURLEvent(url: _controllerUrl.text));
                        }
                      },
                    ),
                    SizedBox(width: 10.w),
                  ],
                ),
                SizedBox(height: 10.w),
              ],
            ),
          )
        ],
      ),
    );
  }
}
