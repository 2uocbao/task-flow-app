import 'package:easy_localization/easy_localization.dart';
import 'package:taskflow/src/data/model/contact/contact_data.dart';
import 'package:taskflow/src/utils/app_export.dart';
import 'package:taskflow/src/utils/validation_functions.dart';
import 'package:taskflow/src/views/create_team_dialog/bloc/create_team_bloc.dart';
import 'package:taskflow/src/views/create_team_dialog/bloc/create_team_event.dart';
import 'package:taskflow/src/views/create_team_dialog/bloc/create_team_state.dart';
import 'package:taskflow/src/widgets/add_member_widget.dart';

class CreateTeamDialog extends StatefulWidget {
  static Widget builder(BuildContext context) {
    return BlocProvider<CreateTeamBloc>(
      create: (context) => CreateTeamBloc(const CreateTeamState()),
      child: const CreateTeamDialog(),
    );
  }

  const CreateTeamDialog({super.key});

  @override
  State<CreateTeamDialog> createState() => _CreateTeamDialogState();
}

class _CreateTeamDialogState extends State<CreateTeamDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<AddMemberWidgetState> addMemberKey = GlobalKey();
  final _nameController = TextEditingController();
  bool isAddMember = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTeamBloc, CreateTeamState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            // addMemberKey.currentState?.reset();
          },
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusStyle.circleBorder5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        _buildAppBar(context),
                        _buildBody(context, state),
                      ],
                    ),
                  )
                ],
              )),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      centerTitle: true,
      title: Text(
        'lbl_create_new_team'.tr(),
        style: Theme.of(context).textTheme.headlineLarge,
      ),
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
    );
  }

  Widget _buildBody(BuildContext context, CreateTeamState state) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'lbl_team_name'.tr(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          CustomTextFormField(
            textInputAction: TextInputAction.next,
            controller: _nameController,
            validator: (value) {
              if (!isText(value) || value!.isEmpty) {
                return "err_please_enter_valid_text".tr();
              }
              return null;
            },
          ),
          SizedBox(height: 5.h),
          // Row(
          //   children: [
          //     Text(
          //       'lbl_team_members'.tr(),
          //       style: Theme.of(context).textTheme.bodySmall,
          //     ),
          //     const Spacer(),
          //     CustomIconButton(
          //       child: Icon(
          //           !isAddMember
          //               ? Icons.add_circle_outline
          //               : Icons.add_task_outlined,
          //           size: 25.sp),
          //       onTap: () {
          //         setState(() {
          //           isAddMember = !isAddMember;
          //         });
          //       },
          //     )
          //   ],
          // ),
          // if (isAddMember) ...{
          //   AddMemberWidget(
          //     key: addMemberKey,
          //     height: 80.h,
          //     addMember: (contactData) {
          //       context.read<CreateTeamBloc>().add(AddMemberEvent(contactData));
          //     },
          //   )
          // },
          SizedBox(height: 5.h),
          if (state.contactDatas.isNotEmpty) ...{
            _buildSelectMembers(context, state.contactDatas)
          },
          SizedBox(height: 5.h),
          CustomTextButton(
            text: 'bt_create_team'.tr(),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadiusStyle.circleBorder30,
            ),
            buttonTextStyle: Theme.of(context).textTheme.titleLarge,
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                context
                    .read<CreateTeamBloc>()
                    .add(CreateEvent(_nameController.text));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectMembers(
      BuildContext context, List<ContactData> contactDatas) {
    return SizedBox(
      height: 70.h,
      width: double.maxFinite,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contactDatas.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 5.h),
            child: Column(
              children: [
                Stack(
                  children: [
                    CustomCircleAvatar(
                      imagePath: contactDatas[index].image!,
                      size: 50,
                    ),
                    Positioned(
                      bottom: 25.h,
                      left: 25.h,
                      child: CustomIconButton(
                        height: 20.h,
                        width: 20.w,
                        onTap: () {
                          context
                              .read<CreateTeamBloc>()
                              .add(RemoveMemberEvent(contactDatas[index].id!));
                        },
                        child: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                          size: 20.sp,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    maxLines: 2,
                    contactDatas[index].userName!,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
