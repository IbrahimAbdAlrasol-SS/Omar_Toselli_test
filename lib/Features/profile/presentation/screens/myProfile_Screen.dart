
import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/widgets/Others/CustomAppBar.dart';
import 'package:Tosell/core/widgets/Others/custom_phoneNumbrt.dart';
import 'package:Tosell/core/widgets/layouts/custom_section.dart';
import 'package:Tosell/features/auth/registration/presentation/screens/register_screen.dart';
import 'package:Tosell/features/profile/presentation/providers/profile_provider.dart';
import 'package:Tosell/features/profile/presentation/screens/TermsAndConditions_Screen.dart';
import 'package:Tosell/features/profile/presentation/screens/commonQuestions_Screen.dart';
import 'package:Tosell/features/profile/presentation/screens/logout_Screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
 

var ProfileImage = 'assets/images/interest1.jpeg';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});
  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var profileState = ref.watch(profileNotifierProvider);
    Size size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.06),
          child: Column(
            children: [
              profileState.when(
                data: (user) => CustomAppBar(
                  title: user.userName ?? 'لايوجد',
                  subtitle:
                      customPhoneNumber(user.phoneNumber ?? "00000000000"),
                  showBackButton: false,
                  buttonWidget: CircleAvatar(
                    backgroundImage: user.img == null
                        ? const AssetImage('assets/images/default_avatar.jpg')
                        : NetworkImage(imageUrl + user.img!),
                  ),
                ),
                error: (error, _) => Text(error.toString()),
                loading: () => const CircularProgressIndicator(),
              ),
              buildLine(size),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CustomSection(
                        title: "الدعم الفني",
                        children: [
                          buildSection(
                              "تواصل مع الدعم", "assets/svg/support.svg", theme,
                              onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ));
                          }),
                          buildSection(
                            "قائمة الدعم السابق",
                            "assets/svg/reseves.svg",
                            theme,
                          ),
                          buildSection(
                            "الأسألة الشائعة",
                            "assets/svg/Question.svg",
                            theme,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CommonQuestionsScreen(),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  CustomSection(
                    title: "تفاصيل الحساب",
                    children: [
                      buildSection(
                        "تعديل المعلومات",
                        "assets/svg/pin.svg",
                        theme,
                        onTap: () => context.push(AppRoutes.editProfile),
                      ),
                      buildSection(
                        "تغيير كلمة السر",
                        "assets/svg/09. Password.svg",
                        theme,
                        onTap: () => context.push(AppRoutes.changePassword),
                      ),
                      buildSection(
                          "عناوين الإستلام", "assets/svg/location.svg", theme,
                          onTap: () {
                        context.push(AppRoutes.zones,
                            extra: "عناوين إستلام البضاعة");
                      }),
                    ],
                  ),
                  CustomSection(
                    title: "المعاملات المالية",
                    children: [
                      buildSection("قائمة المعاملات المالية",
                          "assets/svg/coines.svg", theme,
                          onTap: () => GoRouter.of(context)
                              .push(AppRoutes.transactions)),
                    ],
                  ),
                  CustomSection(
                    title: "التطبيق",
                    children: [
                      buildSection(
                        "الإشعارات",
                        "assets/svg/notifications.svg",
                        theme,
                        onTap: () =>
                            GoRouter.of(context).push(AppRoutes.notifications),
                      ),
                      buildSection(
                        "إعدادات المظهر",
                        "assets/svg/theme.svg",
                        theme,
                        onTap: () =>
                            GoRouter.of(context).push(AppRoutes.themeSettings),
                      ),
                      // buildSection(
                      //   "اللغة",
                      //   "assets/svg/language.svg",
                      //   theme,
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => const LanguageScreen(),
                      //         ));
                      //   },
                      // ),
                      buildSection(
                          "الشروط و الأحكام", "assets/svg/lock.svg", theme,
                          onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsAndConditions(),
                            ));
                      }),
                    ],
                  ),
                  CustomSection(
                    title: "الحساب",
                    children: [
                      buildSection(
                        "تسجيل الخروج",
                        "assets/svg/logout.svg",
                        theme,
                        isRed: true,
                        onTap: () => showModalBottomSheet(
                          isScrollControlled: true,
                          useRootNavigator: true, // ✅ Add this line
                          context: context,
                          builder: (BuildContext context) {
                            return const LogoutScreen();
                          },
                        ),
                      ),
                      buildSection("حذف الحساب", "assets/svg/trash.svg", theme,
                          isGray: true,
                          onTap: () => context.push(AppRoutes.deleteAccount)),
                    ],
                  ),
                  const Gap(AppSpaces.large),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, String iconPath, ThemeData theme,
      {bool isRed = false, bool isGray = false, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: title == "عناوين الإستلام"
                  ? const EdgeInsets.only(
                      top: 10, bottom: 10, right: 19, left: 10)
                  : const EdgeInsets.all(10),
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 20,
                color: isRed == true
                    ? theme.colorScheme.error
                    : isGray == true
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.primary,
              ),
            ),
            if (title == "عناوين الإستلام") const Gap(5),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.secondary,
                fontFamily: "Tajawal",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildLine(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.023, bottom: 0.023),
      child: SizedBox(
        height: 1,
        width: size.width * 0.93,
        child: Container(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
    );
  }
}
