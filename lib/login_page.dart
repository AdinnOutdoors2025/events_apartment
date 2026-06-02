import 'package:apartment_project/theme/app_colors.dart';
import 'package:apartment_project/theme/app_images.dart';
import 'package:apartment_project/utils/validators.dart';
import 'package:apartment_project/widgets/custom_button.dart';
import 'package:apartment_project/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'viewmodel/login_viewmodel.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final viewModel = ref.read(loginViewModelProvider.notifier);
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            final headerHeight = isKeyboardOpen
                ? screenHeight * 0.32
                : screenHeight * 0.46;

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  height: headerHeight,
                  child: LoginHeader(height: headerHeight),
                ),

                Expanded(
                  child: Transform.translate(
                    offset: Offset(0, isKeyboardOpen ? -25 : -40),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: screenWidth - 52,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Apartment Events',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.red,
                                ),
                              ),

                              const SizedBox(height: 5),

                              if (!isKeyboardOpen) ...[
                                const Text(
                                  'Manage events, collect visitor details, connect brands and residents.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.3,
                                    color: AppColors.textGrey,
                                  ),
                                ),

                                const SizedBox(height: 14),

                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FeatureItem(
                                      icon: Icons.calendar_month_outlined,
                                      title: 'Events Management',
                                    ),
                                    FeatureItem(
                                      icon: Icons.badge_outlined,
                                      title: 'Visitors Management',
                                    ),
                                    FeatureItem(
                                      icon: Icons.campaign_outlined,
                                      title: 'Brand Activations',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                              ] else
                                const SizedBox(height: 20),
                              LoginForm(state: state, viewModel: viewModel),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  final double height;

  const LoginHeader({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          AppImages.background,
          width: double.infinity,
          height: height,
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 130,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.white70, Colors.white],
              ),
            ),
          ),
        ),

        Positioned(
          left: 0,
          right: -5,
          bottom: 35,
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(AppImages.logo, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginForm extends StatelessWidget {
  final LoginState state;
  final LoginViewModel viewModel;

  const LoginForm({super.key, required this.state, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: viewModel.formKey,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 35,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              prefixIcon: Icons.person_outline,
              hintText: 'Phone',
              iconColor: Colors.red,
              keyboardType: TextInputType.number,
              controller: viewModel.phoneController,
              onChanged: (value) => viewModel.onPhoneChanged(value, context),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              focusNode: viewModel.phoneFocus,
              validator: (value) => Validator.validate(value, "Phone number"),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              prefixIcon: Icons.lock_outline,
              hintText: 'Password',
              obscureText: state.obscurePassword,
              suffixIcon: state.obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              iconColor: Colors.red,
              controller: viewModel.passwordController,
              focusNode: viewModel.passwordFocus,
              onSuffixTap: viewModel.togglePasswordVisibility,
              validator: (value) => Validator.validate(value, "Password"),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              isLoading: state.isLoading,
              onPressed: () async {
                final success = await viewModel.login();
                if (success && context.mounted) {
                  Navigator.pushReplacementNamed(context, '/bottomNav');
                }
              },
              radius: 14,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.red, size: 30),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
