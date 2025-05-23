import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/utils/utils.dart';
import 'package:taskflow/src/utils/validation_functions.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_bloc.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_event.dart';
import 'package:taskflow/src/views/create_new_task_dialog/bloc/create_new_task_state.dart';
import 'package:taskflow/src/widgets/custom_text_button.dart';
import 'package:taskflow/src/utils/app_export.dart';

class CreateNewTaskDialog extends StatelessWidget {
  CreateNewTaskDialog({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<CreateNewTaskBloc>(
      create: (context) => CreateNewTaskBloc(
        CreateNewTaskState(),
      )..add(CreateNewTaskInitialEvent()),
      child: CreateNewTaskDialog(),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateNewTaskBloc, CreateNewTaskState>(
      listener: (context, state) {
        if (state is CreateNewTaskSuccessState) {
          if (state.isSuccess) {
            NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadiusStyle.customBorderT5,
              ),
              child: Column(
                children: [
                  _buildAppBar(context),
                  _buildTaskNameInput(context),
                  SizedBox(
                    height: 5.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "lbl_due_at".tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDueAtInput(context),
                      _buildDropPriority(context),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "lbl_description".tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  _buildTaskDescriptionInput(context),
                  SizedBox(
                    height: 5.h,
                  ),
                  _buildCreateButton(context),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leading: Transform.rotate(
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
      ),
      centerTitle: true,
      title: Text(
        "lbl_create_new_task".tr(),
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildTaskNameInput(BuildContext context) {
    return BlocSelector<CreateNewTaskBloc, CreateNewTaskState,
        TextEditingController?>(
      selector: (state) => state.taskNameInputController,
      builder: (context, state) {
        return CustomTextFormField(
          controller: state,
          hintText: "lbl_name_task".tr(),
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(),
          contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 15.h),
          validator: (value) {
            if (!isText(value) || value!.isEmpty) {
              return "err_please_enter_valid_text".tr();
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildTaskDescriptionInput(BuildContext context) {
    return BlocSelector<CreateNewTaskBloc, CreateNewTaskState,
        TextEditingController?>(
      selector: (state) => state.taskDescriptionInputController,
      builder: (context, state) {
        return CustomTextFormField(
          controller: state,
          hintText: "lbl_description".tr(),
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(),
          textInputAction: TextInputAction.done,
          maxLines: 1,
          contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
        );
      },
    );
  }

  Widget _buildDueAtInput(BuildContext context) {
    return BlocSelector<CreateNewTaskBloc, CreateNewTaskState,
        TextEditingController?>(
      selector: (state) => state.taskDueAtInputController,
      builder: (context, state) {
        return CustomTextFormField(
          autofocus: false,
          readOnly: true,
          width: 155.w,
          controller: state,
          alignment: Alignment.centerLeft,
          contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 0.w, 5.h),
          onTap: () {
            onTapDueAtInput(context);
          },
        );
      },
    );
  }

  Widget _buildDropPriority(BuildContext context) {
    List<String> trans =
        Utils().priorityItems.map((priority) => priority.tr()).toList();
    int indexPriority;
    return BlocSelector<CreateNewTaskBloc, CreateNewTaskState,
        CreateNewTaskState>(
      selector: (state) => state,
      builder: (context, state) {
        return CustomDropdownButton(
          textStyle: Theme.of(context).textTheme.bodyMedium,
          items: trans,
          value: state.priority!.tr(),
          onChanged: (value) {
            indexPriority = trans.indexOf(value!);
            String? priority = Utils().priorityItems[indexPriority];
            context
                .read<CreateNewTaskBloc>()
                .add(ChangePriorityEvent(priority));
          },
        );
      },
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          CustomTextButton(
            text: "bt_create".tr(),
            buttonTextStyle: Theme.of(context).textTheme.titleLarge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadiusStyle.circleBorder30,
            ),
            onPressed: () {
              onTapCreate(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> onTapDueAtInput(BuildContext context) async {
    var initialState = BlocProvider.of<CreateNewTaskBloc>(context).state;
    DateTime? dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 2));
    if (dateTime != null) {
      TimeOfDay? timeOfDay = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.inputOnly,
      );
      if (timeOfDay != null) {
        dateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );
        initialState.taskDueAtInputController?.text =
            dateTime.format(pattern: D_M_Y_HH_mm);
        // ignore: use_build_context_synchronously
        context.read<CreateNewTaskBloc>().add(ChangeDateEvent(date: dateTime));
      }
    }
  }

  onTapCreate(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<CreateNewTaskBloc>().add(
            CreateTaskEvent(),
          );
    }
  }
}
