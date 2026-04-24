import 'package:easy_localization/easy_localization.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/ui/app_dialogs.dart';
import 'package:ecommerce_app/core/ui/app_spacing.dart';
import 'package:ecommerce_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:ecommerce_app/features/profile/presentation/widgets/profile_settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:iconly/iconly.dart';

class ProfilePageBody extends StatefulWidget {
  const ProfilePageBody({super.key});

  @override
  State<ProfilePageBody> createState() => _ProfilePageBodyState();
}

class _ProfilePageBodyState extends State<ProfilePageBody> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          AppSpacing.h12,
          const ProfileHeader(),
          AppSpacing.h32,
          // Settings Group
          ProfileSettingsTile(
            icon: IconlyLight.notification,
            title: 'profile.notification'.tr(),
            onTap: () {},
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
          ),
          ProfileSettingsTile(
            icon: IconlyLight.heart,
            title: 'profile.favorite'.tr(),
            onTap: () => context.push(AppRouter.favorites),
          ),
          ProfileSettingsTile(
            icon: IconlyLight.bag,
            title: 'profile.cart'.tr(),
            onTap: () {},
          ),
          ProfileSettingsTile(
            icon: IconlyLight.buy,
            title: 'profile.orders'.tr(),
            onTap: () {},
          ),
          ProfileSettingsTile(
            icon: IconlyLight.star,
            title: 'profile.rate_app'.tr(),
            onTap: () {},
          ),
          ProfileSettingsTile(
            icon: IconlyLight.lock,
            title: 'profile.privacy_policy'.tr(),
            onTap: () {},
          ),
          ProfileSettingsTile(
            icon: IconlyLight.document,
            title: 'profile.terms_conditions'.tr(),
            onTap: () {},
          ),
          ProfileSettingsTile(
            icon: IconlyLight.message,
            title: 'profile.contact'.tr(),
            onTap: () {},
          ),
          ProfileSettingsTile(
            icon: IconlyLight.chat,
            title: 'profile.feedback'.tr(),
            onTap: () {},
          ),
          ProfileSettingsTile(
            icon: IconlyLight.logout,
            title: 'profile.logout'.tr(),
            onTap: () async {
              final confirm = await AppDialogs.showLogoutDialog(context);
              if (confirm != true) return;
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              context.read<AuthCubit>().logout();
            },
            isDestructive: true,
          ),
          AppSpacing.h64, // Extra space for navigation bar
        ],
      ),
    );
  }
}
