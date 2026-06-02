import 'package:apartment_project/utils/snackbar.dart';
import 'package:apartment_project/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/get_list_model.dart';
import '../theme/app_colors.dart';
import '../utils/validators.dart';
import '../viewmodel/add_apartment_viewmodel.dart';

class AddApartmentScreen extends ConsumerStatefulWidget {
  final Apartment? apartment;
  final bool showAppBar;

  const AddApartmentScreen({super.key, this.apartment, this.showAppBar = true});

  bool get isEdit => apartment != null;

  @override
  ConsumerState<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends ConsumerState<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController apartmentNameController;
  late final TextEditingController contactPhoneController;
  late final TextEditingController locationController;
  late final TextEditingController geoLocationController;
  late final TextEditingController accountHolderController;
  late final TextEditingController bankNameController;
  late final TextEditingController accountNumberController;
  late final TextEditingController ifscController;
  late final TextEditingController phoneController;
  late final TextEditingController upiController;
  late final TextEditingController residencyController;
  late final TextEditingController approxPeopleController;
  late final TextEditingController fromTGController;
  late final TextEditingController toTGController;
  late final TextEditingController rentController;
  late final TextEditingController ratingController;

  @override
  void initState() {
    super.initState();

    apartmentNameController = TextEditingController();
    contactPhoneController = TextEditingController();
    locationController = TextEditingController();
    geoLocationController = TextEditingController();

    accountHolderController = TextEditingController();
    bankNameController = TextEditingController();
    accountNumberController = TextEditingController();
    ifscController = TextEditingController();
    phoneController = TextEditingController();
    upiController = TextEditingController();

    residencyController = TextEditingController();
    approxPeopleController = TextEditingController();
    fromTGController = TextEditingController();
    toTGController = TextEditingController();
    rentController = TextEditingController();
    ratingController = TextEditingController();
    if (widget.apartment == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(apartmentFormProvider.notifier).resetForm();
      });
    } else {
      if (widget.apartment != null) {
        final apartment = widget.apartment!;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(apartmentFormProvider.notifier).loadApartment(apartment);
          print("API City : ${apartment.city}");
          print("API State : ${apartment.state}");
          apartmentNameController.text = apartment.apartmentName ?? '';

          contactPhoneController.text = apartment.contactPersonPhone ?? '';

          locationController.text = apartment.location ?? '';

          geoLocationController.text = apartment.jioLocation ?? '';

          accountHolderController.text =
              apartment.bankDetails?.accountName ?? '';

          bankNameController.text = apartment.bankDetails?.bankName ?? '';

          accountNumberController.text =
              apartment.bankDetails?.accountNumber ?? '';

          ifscController.text = apartment.bankDetails?.ifscCode ?? '';

          phoneController.text = apartment.bankDetails?.phoneNumber ?? '';

          upiController.text = apartment.bankDetails?.upiId ?? '';

          residencyController.text = apartment.residencyCount?.toString() ?? '';

          approxPeopleController.text =
              apartment.approxPeopleCount?.toString() ?? '';

          fromTGController.text = apartment.fromTGValues?.toString() ?? '';

          toTGController.text = apartment.toTGValues?.toString() ?? '';

          rentController.text = apartment.perDayRent?.toString() ?? '';

          ratingController.text = apartment.rating?.toString() ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    apartmentNameController.dispose();
    contactPhoneController.dispose();
    locationController.dispose();
    geoLocationController.dispose();

    accountHolderController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    phoneController.dispose();
    upiController.dispose();

    residencyController.dispose();
    approxPeopleController.dispose();
    fromTGController.dispose();
    toTGController.dispose();
    rentController.dispose();
    ratingController.dispose();

    super.dispose();
  }

  final List<String> cities = const [
    'Chennai',
    'Madurai',
    'Coimbatore',
    'Trichy',
    'Salem',
    'Tirunelveli',
  ];

  final List<String> states = const [
    'Tamil Nadu',
    'Kerala',
    'Karnataka',
    'Andhra Pradesh',
  ];

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(apartmentFormProvider);
    final notifier = ref.read(apartmentFormProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              title: Text(
                widget.isEdit ? "Edit Apartment" : "Add Apartment",
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                    child: Column(
                      children: [
                        _SectionTitle(
                          title: 'Apartment Details',
                          icon: Icons.apartment_rounded,
                        ),

                        const SizedBox(height: 16),

                        _AppTextField(
                          label: 'Apartment Name',
                          hint: 'Enter apartment name',
                          icon: Icons.apartment_rounded,
                          validator: (value) =>
                              Validator.validate(value, "Apartment name"),
                          onChanged: notifier.updateApartmentName,
                          controller: apartmentNameController,
                        ),
                        const SizedBox(height: 10),
                        _AppTextField(
                          label: 'Contact Person Phone',
                          hint: 'Enter phone number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (value) =>
                              Validator.validate(value, "phone number"),
                          onChanged: notifier.updateContactPhone,
                          controller: contactPhoneController,
                        ),
                        const SizedBox(height: 10),
                        _TwoColumnRow(
                          left: _AppDropdownField(
                            label: 'State',
                            hint: 'Select state',
                            icon: Icons.map_outlined,
                            items: states,
                            hintText: 12,
                            validator: (value) =>
                                Validator.validate(value, "Select state"),
                            onChanged: (value) {
                              notifier.updateStateName(value ?? '');
                            },
                            value: formState.state,
                          ),
                          right: _AppDropdownField(
                            label: 'City',
                            hint: 'Select city',
                            icon: Icons.location_on_outlined,
                            items: cities,
                            hintText: 12,
                            validator: (value) =>
                                Validator.validate(value, "Select city"),
                            onChanged: (value) {
                              notifier.updateCity(value ?? '');
                            },
                            value: formState.city,
                          ),
                        ),

                        const SizedBox(height: 10),
                        _AppTextField(
                          label: 'Location',
                          hint: 'Enter location',
                          icon: Icons.location_on_outlined,
                          validator: (value) =>
                              Validator.validate(value, "location"),
                          onChanged: notifier.updateLocation,
                          controller: locationController,
                        ),

                        const SizedBox(height: 10),
                        _AppTextField(
                          label: 'Geo Location',
                          hint: 'Enter geo location',
                          icon: Icons.my_location_rounded,
                          onChanged: notifier.updateJioLocation,
                          controller: geoLocationController,
                        ),

                        const SizedBox(height: 22),
                        const _DividerLine(),
                        const SizedBox(height: 18),

                        _SectionTitle(
                          title: 'Bank Details',
                          icon: Icons.account_balance_rounded,
                        ),

                        const SizedBox(height: 16),

                        _AppTextField(
                          label: 'Account Holder Name',
                          hint: 'Enter account holder name',
                          icon: Icons.person_outline_rounded,
                          onChanged: notifier.updateAccountHolder,
                          controller: accountHolderController,
                        ),
                        const SizedBox(height: 12),
                        _AppTextField(
                          label: 'Bank Name',
                          hint: 'Enter bank name',
                          icon: Icons.account_balance_outlined,
                          onChanged: notifier.updateBankName,
                          controller: bankNameController,
                        ),

                        const SizedBox(height: 14),

                        _AppTextField(
                          label: 'Account Number',
                          hint: 'Enter account number',
                          icon: Icons.credit_card_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: notifier.updateAccountNumber,
                          controller: accountNumberController,
                        ),
                        const SizedBox(height: 14),
                        _AppTextField(
                          label: 'IFSC Code',
                          hint: 'Enter IFSC code',
                          icon: Icons.verified_user_outlined,
                          textCapitalization: TextCapitalization.characters,
                          onChanged: notifier.updateIfscCode,
                          controller: ifscController,
                        ),

                        const SizedBox(height: 14),

                        _AppTextField(
                          label: 'Phone Number',
                          hint: 'Enter phone number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: notifier.updatePhoneNumber,
                          controller: phoneController,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _AppTextField(
                          label: 'UPI ID',
                          hint: 'Enter UPI ID',
                          icon: Icons.send_outlined,
                          onChanged: notifier.updateUpiId,
                          controller: upiController,
                        ),

                        const SizedBox(height: 22),
                        const _DividerLine(),
                        const SizedBox(height: 18),

                        _SectionTitle(
                          title: 'Other Details',
                          icon: Icons.assignment_outlined,
                        ),

                        const SizedBox(height: 14),

                        _TwoColumnRow(
                          left: _AppTextField(
                            label: 'Residency Count',
                            hint: 'Enter residency count',
                            icon: Icons.groups_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: notifier.updateResidencyCount,
                            controller: residencyController,
                          ),
                          right: _AppTextField(
                            label: 'Approx. People Count',
                            hint: 'Enter approx. people count',
                            icon: Icons.diversity_3_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: notifier.updateApproxPeople,
                            controller: approxPeopleController,
                          ),
                        ),

                        const SizedBox(height: 14),

                        _TwoColumnRow(
                          left: _AppTextField(
                            label: 'From TG Values',
                            hint: 'Enter from TG value',
                            icon: Icons.sell_outlined,
                            onChanged: notifier.updateFromTG,
                            controller: fromTGController,
                            validator: (value) =>
                                Validator.validate(value, "fromTG values"),
                          ),
                          right: _AppTextField(
                            label: 'To TG Values',
                            hint: 'Enter to TG value',
                            icon: Icons.sell_outlined,
                            onChanged: notifier.updateToTG,
                            controller: toTGController,
                            validator: (value) =>
                                Validator.validate(value, "toTG values"),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _AppTextField(
                          label: 'Per Day Rent',
                          hint: 'Enter per day rent',
                          icon: Icons.currency_rupee_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) =>
                              Validator.validate(value, "per day rent"),
                          onChanged: notifier.updatePerDayRent,
                          controller: rentController,
                        ),
                        SizedBox(height: 10),
                        _AppTextField(
                          label: 'Rating (1 to 5, .5 allowed)',
                          hint: 'Enter rating',
                          icon: Icons.star_border_rounded,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,1}'),
                            ),
                          ],
                          /* validator: (value) =>
                              Validator.validate(value, "rating"),*/
                          onChanged: notifier.updateRating,
                          controller: ratingController,
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: widget.isEdit ? 'Edit' : 'Save',
                          radius: 14,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            final hasUpi = upiController.text.trim().isNotEmpty;

                            final bankFields = [
                              accountHolderController.text.trim(),
                              bankNameController.text.trim(),
                              accountNumberController.text.trim(),
                              ifscController.text.trim(),
                              phoneController.text.trim(),
                            ];

                            final filledBankFields = bankFields
                                .where((e) => e.isNotEmpty)
                                .length;
                            if (!hasUpi) {
                              if (filledBankFields == 0) {
                                AppToast.showError(
                                  "Provide either UPI ID or bank details",
                                );
                                return;
                              }

                              if (filledBankFields < bankFields.length) {
                                AppToast.showError(
                                  "Complete all bank details or provide UPI ID",
                                );
                                return;
                              }
                            }
                            try {
                              await ref
                                  .read(apartmentFormProvider.notifier)
                                  .saveApartment();

                              if (!mounted) return;

                              AppToast.showSuccess(
                                widget.isEdit
                                    ? "Apartment updated successfully"
                                    : "Apartment added successfully",
                              );

                              Navigator.pop(context, true);
                            } catch (e) {
                              if (!mounted) return;

                              AppToast.showError(e.toString());
                            }
                          },
                          borderColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _ratingValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }

    final rating = double.tryParse(value);

    if (rating == null) {
      return 'Invalid rating';
    }

    if (rating < 1 || rating > 5) {
      return '1 to 5 only';
    }

    if ((rating * 10) % 5 != 0) {
      return '.5 allowed only';
    }

    return null;
  }
}

class AppColor {
  static const Color primaryRed = Color(0xffEF1B1B);
  static const Color border = Color(0xffD6DAE1);
  static const Color hint = Color(0xff7B8190);
  static const Color text = Color(0xff111111);
  static const Color icon = Color(0xff5F6673);
  static const Color lightRed = Color(0xffFFECEC);
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColor.primaryRed,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TwoColumnRow extends StatelessWidget {
  final Widget left;
  final Widget right;

  const _TwoColumnRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}

class _AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final double? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  const _AppTextField({
    this.controller,
    required this.label,
    required this.hint,
    this.hintText,
    required this.icon,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.suffix,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return _FieldLabelWrapper(
      label: label,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        style: const TextStyle(
          color: AppColor.text,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: _inputDecoration(
          hint: hint,
          hintText: hintText ?? 13,
          icon: icon,
          suffix: suffix,
        ),
      ),
    );
  }
}

class _AppDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final double? hintText;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const _AppDropdownField({
    required this.label,
    required this.hint,
    this.hintText,
    required this.icon,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return _FieldLabelWrapper(
      label: label,
      child: DropdownButtonFormField<String>(
        value: (value != null && value!.isNotEmpty && items.contains(value))
            ? value
            : null,
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: hintText ?? 14,
            color: AppColor.hint,
            fontWeight: FontWeight.w400,
          ),
        ),
        validator: validator,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColor.icon,
        ),
        decoration: _inputDecoration(
          hint: hint,
          hintText: hintText ?? 5,
          icon: icon,
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _FieldLabelWrapper extends StatelessWidget {
  final String label;
  final Widget child;

  const _FieldLabelWrapper({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColor.text,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

InputDecoration _inputDecoration({
  required String hint,
  double? hintText,
  required IconData icon,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: AppColor.hint,
      fontSize: hintText,
      fontWeight: FontWeight.w400,
    ),
    prefixIcon: Icon(icon, size: 21, color: AppColor.icon),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColor.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColor.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColor.primaryRed, width: 1.2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColor.primaryRed),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColor.primaryRed),
    ),
  );
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xffE5E7EB));
  }
}
