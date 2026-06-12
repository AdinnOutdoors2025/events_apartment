import 'package:apartment_project/utils/helpers.dart';
import 'package:apartment_project/utils/snackbar.dart';
import 'package:apartment_project/widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/get_list_model.dart';
import '../theme/app_colors.dart';
import '../utils/validators.dart';
import '../viewmodel/add_apartment_viewmodel.dart';
import '../viewmodel/apartment_viewmodel.dart';
import 'apartment_details_screen.dart';

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
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController apartmentGroupController;
  late final TextEditingController apartmentNameController;
  late final TextEditingController contactPhoneController;
  late final TextEditingController contactNameController;
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
  int _resetCounter = 0;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    apartmentGroupController = TextEditingController();
    apartmentNameController = TextEditingController();
    contactPhoneController = TextEditingController();
    contactNameController = TextEditingController();
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
      _hasChanges = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(apartmentFormProvider.notifier).resetForm();
      });
    } else {
      if (widget.apartment != null) {
        final apartment = widget.apartment!;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(apartmentFormProvider.notifier).loadApartment(apartment);

          apartmentGroupController.text = apartment.apartmentGroupName ?? '';
          apartmentNameController.text = apartment.apartmentName ?? '';

          contactPhoneController.text = apartment.contactPersonPhone ?? '';
          contactNameController.text = apartment.contactPersonName ?? '';

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

          fromTGController.text = apartment.fromTGValues != null
              ? Helpers().numberFormatter.format(apartment.fromTGValues)
              : '';

          toTGController.text = apartment.toTGValues != null
              ? Helpers().numberFormatter.format(apartment.toTGValues)
              : '';

          rentController.text = apartment.perDayRent != null
              ? Helpers().numberFormatter.format(apartment.perDayRent)
              : '';

          ratingController.text = apartment.rating?.toString() ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    apartmentGroupController.clear();
    apartmentNameController.clear();
    contactPhoneController.dispose();
    contactNameController.dispose();
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

  void _markChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  final List<String> cities = const [
    'Chennai',
    'Madurai',
    'Coimbatore',
    'Trichy',
    'Salem',
    'Tirunelveli',
  ];

  final List<String> states = const ['TamilNadu'];

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
                controller: _scrollController,
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
                          label: 'Apartment Group Name',
                          hint: 'Enter Name',
                          icon: Icons.apartment_rounded,
                          // onChanged: notifier.updateApartmentGroupName,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateApartmentGroupName(value);
                          },
                          controller: apartmentGroupController,
                        ),
                        const SizedBox(height: 10),
                        _AppTextField(
                          label: 'Apartment Name',
                          hint: 'Enter Apartment Name',
                          icon: Icons.apartment_outlined,
                          validator: (value) =>
                              Validator.name(value, "Apartment Name"),
                          //  onChanged: notifier.updateApartmentName,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateApartmentName(value);
                          },
                          controller: apartmentNameController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 10),
                        _AppTextField(
                          label: 'Phone Number',
                          hint: 'Enter Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: Validator.phone,
                          //   onChanged: notifier.updateContactPhone,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateContactPhone(value);
                          },
                          controller: contactPhoneController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 10),
                        _AppTextField(
                          label: 'Name',
                          hint: 'Enter Name',
                          icon: Icons.person,
                          //   onChanged: notifier.updatePersonName,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updatePersonName(value);
                          },
                          controller: contactNameController,
                        ),
                        const SizedBox(height: 10),
                        _TwoColumnRow(
                          left: _AppDropdownField(
                            key: ValueKey(
                              'state_${formState.state}_$_resetCounter',
                            ),
                            label: 'State',
                            hint: 'Select State',
                            icon: Icons.map_outlined,
                            items: states,
                            hintText: 12,
                            validator: (value) =>
                                Validator.validate(value, "Select State"),
                            /*onChanged: (value) {
                              notifier.updateStateName(value ?? '');
                            },*/
                            onChanged: (value) {
                              _markChanged();
                              notifier.updateStateName(value ?? '');
                            },
                            value: formState.state,
                            isRequired: true,
                          ),
                          right: _AppDropdownField(
                            key: ValueKey(
                              'city_${formState.city}_$_resetCounter',
                            ),
                            label: 'City',
                            hint: 'Select City',
                            icon: Icons.location_on_outlined,
                            items: cities,
                            hintText: 12,
                            validator: (value) =>
                                Validator.validate(value, "Select City"),
                            /* onChanged: (value) {
                              notifier.updateCity(value ?? '');
                            },*/
                            onChanged: (value) {
                              _markChanged();
                              notifier.updateCity(value ?? '');
                            },
                            value: formState.city,
                            isRequired: true,
                          ),
                        ),

                        const SizedBox(height: 10),
                        _AppTextField(
                          label: 'Location',
                          hint: 'Anna Nagar',
                          icon: Icons.location_on_outlined,
                          validator: (value) =>
                              Validator.validate(value, "Location"),
                          //  onChanged: notifier.updateLocation,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateLocation(value);
                          },
                          controller: locationController,
                          isRequired: true,
                        ),

                        const SizedBox(height: 10),
                        _AppTextField(
                          label: 'Geo Location',
                          hint: ' https://www.google.com/maps/place',
                          icon: Icons.my_location_rounded,
                          //   onChanged: notifier.updateJioLocation,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateJioLocation(value);
                          },
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
                          hint: 'Enter Account Holder Name',
                          icon: Icons.person,
                          //  onChanged: notifier.updateAccountHolder,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateAccountHolder(value);
                          },
                          controller: accountHolderController,
                        ),
                        const SizedBox(height: 12),
                        _AppTextField(
                          label: 'Bank Name',
                          hint: 'Enter Bank Name',
                          icon: Icons.account_balance_outlined,
                          //   onChanged: notifier.updateBankName,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateBankName(value);
                          },
                          controller: bankNameController,
                        ),

                        const SizedBox(height: 14),

                        _AppTextField(
                          label: 'Account Number',
                          hint: 'Enter Account Number',
                          icon: Icons.credit_card_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15),
                          ],
                          // onChanged: notifier.updateAccountNumber,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateAccountNumber(value);
                          },
                          controller: accountNumberController,
                          validator: Validator.accountNumber,
                        ),
                        const SizedBox(height: 14),
                        _AppTextField(
                          label: 'IFSC Code',
                          hint: 'Enter IFSC Code',
                          icon: Icons.verified_user_outlined,
                          textCapitalization: TextCapitalization.characters,
                          //   onChanged: notifier.updateIfscCode,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateIfscCode(value);
                          },
                          controller: ifscController,
                          validator: Validator.ifsc,
                        ),

                        const SizedBox(height: 14),

                        _AppTextField(
                          label: 'Phone Number',
                          hint: 'Enter Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          // onChanged: notifier.updatePhoneNumber,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updatePhoneNumber(value);
                          },
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
                          //    onChanged: notifier.updateUpiId,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateUpiId(value);
                          },
                          controller: upiController,
                          validator: Validator.upi,
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
                            hint: 'Enter Residency Count',
                            icon: Icons.groups_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(5),
                            ],
                            //   onChanged: notifier.updateResidencyCount,
                            onChanged: (value) {
                              _markChanged();
                              notifier.updateResidencyCount(value);
                            },
                            controller: residencyController,
                            validator: (value) => Validator.positiveNumber(
                              value,
                              "Residency Count",
                            ),
                            isRequired: true,
                          ),
                          right: _AppTextField(
                            label: 'Approx People Count',
                            hint: 'Enter Approx People Count',
                            icon: Icons.diversity_3_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            // onChanged: notifier.updateApproxPeople,
                            onChanged: (value) {
                              _markChanged();
                              notifier.updateApproxPeople(value);
                            },
                            controller: approxPeopleController,
                            validator: (value) =>
                                Validator.optionalPositiveNumber(value),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _TwoColumnRow(
                          left: _AppTextField(
                            label: 'From TG Values',
                            hint: 'Enter from TG value',
                            icon: Icons.sell_outlined,
                            //  onChanged: notifier.updateFromTG,
                            onChanged: (value) {
                              _markChanged();
                              notifier.updateFromTG(value);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(8),
                              IndianCurrencyInputFormatter(),
                            ],
                            isRequired: true,
                            controller: fromTGController,
                            validator: (value) => Validator.positiveNumber(
                              value,
                              "From TG Value",
                            ),
                          ),
                          right: _AppTextField(
                            label: 'To TG Values',
                            hint: 'Enter to TG value',
                            icon: Icons.sell_outlined,
                            //  onChanged: notifier.updateToTG,
                            onChanged: (value) {
                              _markChanged();
                              notifier.updateToTG(value);
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(8),
                              IndianCurrencyInputFormatter(),
                            ],
                            isRequired: true,
                            controller: toTGController,
                            validator:
                                (value)
                                // Validator.positiveNumber(value, "To TG Value"),
                                {
                                  final error = Validator.positiveNumber(
                                    value,
                                    "To TG Value",
                                  );
                                  if (error != null) return error;

                                  final fromValue =
                                      int.tryParse(
                                        fromTGController.text.replaceAll(
                                          ',',
                                          '',
                                        ),
                                      ) ??
                                      0;

                                  final toValue =
                                      int.tryParse(
                                        value?.replaceAll(',', '') ?? '',
                                      ) ??
                                      0;

                                  if (toValue < fromValue) {
                                    return "Must be ≥ From TG";
                                  }

                                  return null;
                                },
                          ),
                        ),

                        const SizedBox(height: 14),

                        _AppTextField(
                          label: 'Per Day Rent',
                          hint: 'Enter Per day Rent',
                          icon: Icons.currency_rupee_rounded,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(7),
                            IndianCurrencyInputFormatter(),
                          ],
                          isRequired: true,
                          validator: (value) =>
                              Validator.positiveNumber(value, "Per Day Rent"),
                          //  onChanged: notifier.updatePerDayRent,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updatePerDayRent(value);
                          },
                          controller: rentController,
                        ),
                        SizedBox(height: 10),
                        _AppTextField(
                          label: 'Rating',
                          hint: 'Enter rating between 1 and 5 (e.g. 4.5)',
                          icon: Icons.star_border_rounded,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                            LengthLimitingTextInputFormatter(3),
                          ],
                          validator: Validator.rating,
                          //   onChanged: notifier.updateRating,
                          onChanged: (value) {
                            _markChanged();
                            notifier.updateRating(value);
                          },
                          controller: ratingController,
                        ),
                        SizedBox(height: 15),
                        CustomButton(
                          text: 'Save',
                          radius: 14,
                          textColor: Colors.white,
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (widget.isEdit && !_hasChanges) {
                              AppToast.showError("No changes to save");
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
                              if (!widget.isEdit) {
                                ref
                                    .read(apartmentFormProvider.notifier)
                                    .clearApartmentId();
                              }
                              final apartment = await ref
                                  .read(apartmentFormProvider.notifier)
                                  .saveApartment(isEdit: widget.isEdit);
                              if (!mounted) return;

                              AppToast.showSuccess(
                                widget.isEdit
                                    ? "Apartment updated successfully"
                                    : "Apartment added successfully",
                              );
                              if (widget.isEdit) {
                                Navigator.pop(context, true);
                              } else {
                                await ref
                                    .read(
                                      apartmentFamilyProvider(null).notifier,
                                    )
                                    .getApartments();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ApartmentDetailsScreen(
                                      apartment: apartment,
                                    ),
                                  ),
                                ).then((_) {
                                  _clearAddApartmentForm();
                                });
                              }
                            } catch (e) {
                              if (!mounted) return;
                              AppToast.showError(e.toString());
                            }
                          },
                          // borderColor: Colors.red,
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

  void _clearAddApartmentForm() {
    FocusScope.of(context).unfocus();
    if (kDebugMode) {
      print("clearing all controllers");
      print("before clear: ${apartmentNameController.text}");
    }

    _formKey.currentState?.reset();
    ref.read(apartmentFormProvider.notifier).resetForm();
    apartmentGroupController.clear();
    apartmentNameController.clear();
    contactPhoneController.clear();
    contactNameController.clear();
    locationController.clear();
    geoLocationController.clear();

    accountHolderController.clear();
    bankNameController.clear();
    accountNumberController.clear();
    ifscController.clear();
    phoneController.clear();
    upiController.clear();

    residencyController.clear();
    approxPeopleController.clear();
    fromTGController.clear();
    toTGController.clear();
    rentController.clear();
    ratingController.clear();
    setState(() {
      _resetCounter++;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }

      if (kDebugMode) {
        print("after clear: ${apartmentNameController.text}");
      }
    });
  }
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
            color: AppColors.red,
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
  final bool isRequired;
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
    this.isRequired = false,
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
      isRequired: isRequired,
      child: TextFormField(
        controller: controller,

        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,

        style: TextStyle(
          color: AppColors.textGrey,
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
  final bool isRequired;
  final double? hintText;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const _AppDropdownField({
    super.key,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.hintText,
    required this.icon,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValue =
        value != null && value!.trim().isNotEmpty && items.contains(value)
        ? value
        : null;

    return _FieldLabelWrapper(
      label: label,
      isRequired: isRequired,
      child: DropdownButtonFormField<String>(
        key: ValueKey('${label}_${selectedValue ?? ""}'),
        value: selectedValue,
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: hintText ?? 14,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w400,
          ),
        ),
        validator: validator,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.textGrey,
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
  final bool isRequired;

  const _FieldLabelWrapper({
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
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
      color: Colors.grey.shade500,
      fontSize: hintText,
      fontWeight: FontWeight.w400,
    ),
    prefixIcon: Icon(icon, size: 21, color: AppColors.textGrey),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
    /*border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide:  BorderSide(color: Colors.black45),
    ),*/
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColors.red, width: 1.2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: AppColors.red),
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
