import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/theme/custom_button_style.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_bloc.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_event.dart';
import 'package:taskflow/src/views/filter_task_dialog/bloc/filter_task_state.dart';
import 'package:taskflow/src/utils/app_export.dart';

// ignore: must_be_immutable
class FilterTaskDialog extends StatelessWidget {
  FilterTaskDialog({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterTaskBloc(
        const FilterTaskState(),
      ),
      child: FilterTaskDialog(),
    );
  }

  String byTime = PrefUtils().getTimeFilterTask();

  String byPriority = PrefUtils().getPriorityFilterTask();

  String dateStart = PrefUtils().getStartDateCustom();

  String dateEnd = PrefUtils().getEndDateCustom();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterTaskBloc, FilterTaskState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 10.h,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadiusStyle.customBorderT5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppBar(context),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        child: Text(
                          "lbl_by_time".tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterByTime(context, state),
                    ],
                  ),
                  if (byTime == 'CUSTOM') ...{
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("lbl_startDate".tr(),
                            style: Theme.of(context).textTheme.bodySmall),
                        Text("lbl_endDate".tr(),
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    _buildCustomDate(context),
                  },
                  SizedBox(height: 5.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text("lbl_by_priority".tr(),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  SizedBox(height: 5.h),
                  _buildPriorityRow(context),
                  SizedBox(height: 10.h),
                  _buildApplyButton(context),
                  SizedBox(height: 10.h),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leading: CustomIconButton(
        height: 30.h,
        width: 35.w,
        child: Icon(
          Icons.close,
          color: Colors.red,
          size: 30.sp,
        ),
        onTap: () {
          NavigatorService.goBack();
        },
      ),
      centerTitle: true,
      title: Text(
        "lbl_filter_task".tr(),
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildFilterByTime(BuildContext context, FilterTaskState state) {
    List<String> trans = Utils().timeKeys.map((time) => time.tr()).toList();
    int indexValue;
    return CustomDropdownButton(
      textStyle: Theme.of(context).textTheme.bodyMedium,
      items: trans,
      value: byTime.tr(),
      onChanged: (value) => {
        indexValue = trans.indexOf(value!),
        byTime = Utils().timeKeys[indexValue],
        context.read<FilterTaskBloc>().add(
              ChangeTimeEvent(time: value),
            ),
      },
    );
  }

  Widget _buildCustomDate(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSelectedDateStart(context),
        _buildSelectedDateEnd(context),
      ],
    );
  }

  Widget _buildSelectedDateStart(BuildContext context) {
    return CustomTextFormField(
      autofocus: true,
      readOnly: true,
      width: 100.w,
      controller: TextEditingController(text: dateStart),
      alignment: Alignment.center,
      contentPadding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
      onTap: () async {
        DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(dateStart),
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          firstDate: DateTime(DateTime.now().year - 2),
          lastDate: DateTime.tryParse(dateEnd)!,
        );
        if (dateTime != null) {
          dateStart = dateTime.format(pattern: D_M_Y);
          // ignore: use_build_context_synchronously
          context
              .read<FilterTaskBloc>()
              .add(ChangeDateStartEvent(dateStart: dateTime));
        }
      },
    );
  }

  Widget _buildSelectedDateEnd(BuildContext context) {
    return CustomTextFormField(
      autofocus: true,
      readOnly: true,
      width: 100.w,
      controller: TextEditingController(text: dateEnd),
      alignment: Alignment.center,
      contentPadding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
      onTap: () async {
        DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(dateEnd),
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          firstDate: DateTime.tryParse(dateStart)!,
          lastDate: DateTime(DateTime.now().year + 2),
        );
        if (dateTime != null) {
          dateEnd = dateTime.format(pattern: D_M_Y);
          // ignore: use_build_context_synchronously
          context
              .read<FilterTaskBloc>()
              .add(ChangeDateEndEvent(dateEnd: dateTime));
        }
      },
    );
  }

  Widget _buildPriorityRow(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPriorityButton(context, "bt_high"),
          _buildPriorityButton(context, "bt_medium"),
          _buildPriorityButton(context, "bt_low"),
        ],
      ),
    );
  }

  Widget _buildPriorityButton(BuildContext context, String text) {
    return CustomTextButton(
      text: text.tr(),
      buttonTextStyle: Theme.of(context).textTheme.bodyMedium,
      buttonStyle: ElevatedButton.styleFrom(
        backgroundColor: CustomButtonStyle.getButtonColor(
            context, byPriority.toUpperCase().tr() == text.tr()),
        foregroundColor: Colors.black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.circleBorder20,
      ),
      onPressed: () async {
        String? label = await Utils().getEnglishValue(text);
        byPriority = label!;
        // ignore: use_build_context_synchronously
        context
            .read<FilterTaskBloc>()
            .add(ChangePriorityEvent(priority: text.tr()));
      },
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return CustomTextButton(
      text: "bt_apply".tr(),
      buttonTextStyle: Theme.of(context).textTheme.titleLarge,
      decoration: BoxDecoration(
        color: CustomButtonStyle.getButtonColor(context, true),
        borderRadius: BorderRadiusStyle.circleBorder30,
      ),
      onPressed: () {
        PrefUtils().setTimeFilterTask(byTime);
        PrefUtils().setStartDateCustom(dateStart);
        PrefUtils().setEndDateCustom(dateEnd);
        PrefUtils().setPriorityFilterTask(byPriority);
        setTime(byTime);
        NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
      },
    );
  }

  void setTime(String byTime) async {
    DateTime dateTime = DateTime.now();
    if (byTime == 'TODAY') {
      PrefUtils().setStartDateCustom(dateTime.format(pattern: D_M_Y));
      PrefUtils().setEndDateCustom(dateTime.format(pattern: D_M_Y));
    } else if (byTime == 'THIS_WEEK') {
      final weekDay = dateTime.weekday;
      //start Date
      PrefUtils().setStartDateCustom(
          DateTime(dateTime.year, dateTime.month, dateTime.day)
              .subtract(Duration(days: weekDay - 1))
              .format(pattern: D_M_Y));
      //end Date
      PrefUtils().setEndDateCustom(
          DateTime(dateTime.year, dateTime.month, dateTime.day)
              .add(Duration(days: 7 - weekDay))
              .format(pattern: D_M_Y));
    } else if (byTime == 'THIS_MONTH') {
      //start date
      PrefUtils().setStartDateCustom(
          DateTime(dateTime.year, dateTime.month, 1).format(pattern: D_M_Y));

      //end date
      final nextMonth = (dateTime.month == 12)
          ? DateTime(dateTime.year + 1, 1, 1)
          : DateTime(dateTime.year, dateTime.month + 1, 1);
      PrefUtils().setEndDateCustom(nextMonth
          .subtract(const Duration(microseconds: 1))
          .format(pattern: D_M_Y));
    }
  }
}
