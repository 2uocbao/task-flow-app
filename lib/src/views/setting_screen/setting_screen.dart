import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/src/utils/app_export.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  static Widget builder(BuildContext context) {
    return const SettingScreen();
  }

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leading: CustomIconButton(
        height: 30.h,
        child: Icon(Icons.arrow_back_outlined, size: 25.sp),
        onTap: () {
          NavigatorService.pushNamedAndRemoveUtil(AppRoutes.homeScreen);
        },
      ),
      centerTitle: true,
      title: Text(
        'lbl_setting'.tr(),
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 25.sp,
            ),
      ),
    );
  }

  Widget _buildLineSpace() {
    return Container(
      color: LightCodeColors().blueGray100,
      height: 1.h,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: Theme.of(context).colorScheme.surface,
      child: ListView(
        controller: _scrollController,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.only(left: 20.w),
            height: 30.h,
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    content: SelectTheme(),
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    insetPadding: EdgeInsets.zero,
                  ),
                );
              },
              child: Text(
                'lbl_theme'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          _buildLineSpace(),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.only(left: 20.w),
            height: 30.h,
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
                    content: SelectLangueDialog(),
                    backgroundColor: Colors.transparent,
                    contentPadding: EdgeInsets.zero,
                    insetPadding: EdgeInsets.zero,
                  ),
                );
              },
              child: Text(
                'lbl_language'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          _buildLineSpace(),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.only(left: 20.w),
            height: 30.h,
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                AppSettings.openAppSettings(type: AppSettingsType.notification);
              },
              child: Text(
                'lbl_notification'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          _buildLineSpace(),
          Container(
            margin: EdgeInsets.only(top: 10.h),
            padding: EdgeInsets.only(left: 20.w),
            height: 30.h,
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                AppSettings.openAppSettings();
              },
              child: Text(
                'lbl_appPermissions'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          _buildLineSpace(),
          // Container(
          //   margin: EdgeInsets.only(top: 10.h),
          //   padding: EdgeInsets.only(left: 20.w),
          //   height: 30.h,
          //   color: Colors.transparent,
          //   child: GestureDetector(
          //     onTap: () {
          //       logger.i('message');
          //     },
          //     child: Text(
          //       'lbl_app_info'.tr(),
          //       style: Theme.of(context).textTheme.titleLarge,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class SelectTheme extends StatelessWidget {
  const SelectTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    ThemeMode currentMode = provider.themeMode;
    AppThemeMode getSelected() {
      if (currentMode == ThemeMode.light) return AppThemeMode.light;
      if (currentMode == ThemeMode.dark) return AppThemeMode.dark;
      return AppThemeMode.system;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.circleBorder5,
              color: Theme.of(context).colorScheme.surface),
          child: Column(
            children: [
              RadioListTile<AppThemeMode>(
                title: const Text('Light'),
                value: AppThemeMode.light,
                groupValue: getSelected(),
                onChanged: (value) {
                  if (value != null) provider.setTheme(value);
                },
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('Dark'),
                value: AppThemeMode.dark,
                groupValue: getSelected(),
                onChanged: (value) {
                  if (value != null) provider.setTheme(value);
                },
              ),
              RadioListTile<AppThemeMode>(
                title: const Text('System Default'),
                value: AppThemeMode.system,
                groupValue: getSelected(),
                onChanged: (value) {
                  if (value != null) provider.setTheme(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectLangueDialog extends StatelessWidget {
  const SelectLangueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;

    Locale getCurrentLocale() {
      if (currentLocale == const Locale('en')) return const Locale('en');
      return currentLocale;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.circleBorder5,
              color: Theme.of(context).colorScheme.surface),
          child: Column(
            children: [
              RadioListTile<Locale>(
                title: const Text('English'),
                value: const Locale('en'),
                groupValue: getCurrentLocale(),
                onChanged: (value) {
                  if (value != null) context.setLocale(value);
                },
              ),
              RadioListTile<Locale>(
                title: const Text('Tiếng Việt'),
                value: const Locale('vi'),
                groupValue: getCurrentLocale(),
                onChanged: (value) {
                  if (value != null) context.setLocale(value);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomTextButton(
                    text: 'LangueSystem'.tr(),
                    onPressed: () {
                      Locale systemLocale = PlatformDispatcher.instance.locale;
                      Locale systemLocal = Locale(systemLocale.languageCode);
                      context.setLocale(systemLocal);
                    },
                  ),
                  CustomTextButton(
                    text: 'bt_cancel'.tr(),
                    onPressed: () {
                      NavigatorService.goBack();
                    },
                  )
                ],
              ),
              SizedBox(height: 10.h)
            ],
          ),
        ),
      ],
    );
  }
}
