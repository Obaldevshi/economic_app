import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_template/app/app_router.dart';
import 'package:mobile_template/app/layout/app_layout_item_builder.dart';
import 'package:mobile_template/app/theme/app_dimensions.dart';
import 'package:mobile_template/core/di/di.dart';
import 'package:mobile_template/core/extensions/build_context_extensions.dart';
import 'package:mobile_template/core/services/locale_service.dart';
import 'package:mobile_template/core/services/session_service.dart';
import 'package:mobile_template/core/services/theme_service.dart';
import 'package:mobile_template/core/utils/package_info_utils.dart';
import 'package:mobile_template/features/profile/domain/dto/profile_dto.dart';
import 'package:mobile_template/features/profile/presentation/pages/bloc/profile_bloc.dart';
import 'package:mobile_template/features/profile/presentation/widgets/change_password_bottom_sheet.dart';
import 'package:mobile_template/features/profile/presentation/widgets/profile_action_tile.dart';
import 'package:mobile_template/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:mobile_template/presentation/widgets/common/confirmation_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/error_dialog.dart';
import 'package:mobile_template/presentation/widgets/common/glass_surface_card.dart';
import 'package:mobile_template/presentation/widgets/common/global_button.dart';
import 'package:mobile_template/presentation/widgets/layout/scroll_shell.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_locale_switcher.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_section_title.dart';
import 'package:mobile_template/presentation/widgets/ui_kit/ui_kit_theme_switcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = getIt<ThemeService>();
    final localeService = getIt<LocaleService>();
    final sessionService = getIt<SessionService>();

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is GetProfileFailure) {
          ErrorDialog.show(context, state.failure);
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final isLoading = state is GetProfileLoading;
        final profile = state.data.profile;

        if (!isLoading && profile == null) {
          return Center(child: Text(context.l10n.error));
        }

        return ScrollShell(
          isLoading: isLoading,
          title: context.l10n.profile,
          headerContent: isLoading
              ? const SizedBox.shrink()
              : Text(
                  profile!.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
          body: isLoading
              ? const SizedBox.shrink()
              : AppLayoutItemBuilder<Widget>(
                  narrow: () => _buildNarrow(
                    context,
                    profile!,
                    themeService,
                    localeService,
                    sessionService,
                  ),
                  wide: () => _buildWide(
                    context,
                    profile!,
                    themeService,
                    localeService,
                    sessionService,
                  ),
                )(context),
        );
      },
    );
  }

  Widget _buildNarrow(
    BuildContext context,
    ProfileDto profile,
    ThemeService themeService,
    LocaleService localeService,
    SessionService sessionService,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileHeaderCard(profile: profile),
        const SizedBox(height: AppDimensions.spaceL),
        _buildAccount(context, profile),
        const SizedBox(height: AppDimensions.spaceS),
        _buildAppearance(context, themeService, localeService),
        const SizedBox(height: AppDimensions.spaceL),
        _buildVersion(context),
        const SizedBox(height: AppDimensions.spaceXL),
        _buildLogout(context, sessionService),
      ],
    );
  }

  Widget _buildWide(
    BuildContext context,
    ProfileDto profile,
    ThemeService themeService,
    LocaleService localeService,
    SessionService sessionService,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeaderCard(profile: profile),
              const SizedBox(height: AppDimensions.spaceL),
              _buildVersion(context),
              const SizedBox(height: AppDimensions.spaceL),
              _buildLogout(context, sessionService),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spaceL),
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAccount(context, profile),
              const SizedBox(height: AppDimensions.spaceL),
              _buildAppearance(context, themeService, localeService),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccount(BuildContext context, ProfileDto profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UiKitSectionTitle(title: context.l10n.profileSectionAccount),
        ProfileActionTile(
          icon: Icons.account_circle_outlined,
          title: context.l10n.editProfile,
          subtitle: context.l10n.updatePersonalInfo,
          onTap: () async {
            final result = await context.push<bool?>(
              AppRoutes.editProfile,
              extra: profile,
            );
            if (result == true && context.mounted) {
              context.read<ProfileBloc>().add(GetProfileEvent());
            }
          },
        ),
        ProfileActionTile(
          icon: Icons.security_outlined,
          title: context.l10n.changePassword,
          subtitle: context.l10n.security,
          onTap: () => ChangePasswordBottomSheet.show(context),
        ),
      ],
    );
  }

  Widget _buildAppearance(
    BuildContext context,
    ThemeService themeService,
    LocaleService localeService,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UiKitSectionTitle(title: context.l10n.homeSectionAppearance),
        UiKitThemeSwitcher(themeService: themeService),
        const SizedBox(height: AppDimensions.spaceM),
        UiKitLocaleSwitcher(localeService: localeService),
      ],
    );
  }

  Widget _buildVersion(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: PackageInfoUtils.appVersion(),
      builder: (context, snapshot) => GlassSurfaceCard(
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: AppDimensions.spaceM),
            Text(
              '${context.l10n.version} ${snapshot.data ?? '—'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogout(BuildContext context, SessionService sessionService) {
    return GlobalButton(
      text: context.l10n.logout,
      onPressed: () => _handleLogout(context, sessionService),
    );
  }

  Future<void> _handleLogout(
    BuildContext context,
    SessionService sessionService,
  ) async {
    final shouldLogout = await ConfirmationDialog.show(
      context,
      title: context.l10n.logout,
      content: context.l10n.logoutConfirmation,
      confirmText: context.l10n.logout,
      isDestructive: true,
    );

    if (shouldLogout == true) {
      await sessionService.clearSession();
    }
  }
}
