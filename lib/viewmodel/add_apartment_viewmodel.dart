import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/get_list_model.dart';
import '../services/api_service.dart';

class ApartmentFormState {
  final String apartmentId;
  final String apartmentName;
  final String city;
  final String state;
  final String location;
  final String jioLocation;
  final String contactPersonPhone;
  final String accountHolderName;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String phoneNumber;
  final String upiId;
  final String rating;
  final String residencyCount;
  final String approxPeopleCount;
  final String fromTGValues;
  final String toTGValues;
  final String perDayRent;

  const ApartmentFormState({
    this.apartmentId = '',
    this.apartmentName = '',
    this.city = '',
    this.state = '',
    this.location = '',
    this.jioLocation = '',
    this.contactPersonPhone = '',
    this.accountHolderName = '',
    this.bankName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.phoneNumber = '',
    this.upiId = '',
    this.rating = '',
    this.residencyCount = '',
    this.approxPeopleCount = '',
    this.fromTGValues = '',
    this.toTGValues = '',
    this.perDayRent = '',
  });

  ApartmentFormState copyWith({
    String? apartmentId,
    String? apartmentName,
    String? city,
    String? state,
    String? location,
    String? jioLocation,
    String? contactPersonPhone,
    String? accountHolderName,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? phoneNumber,
    String? upiId,
    String? rating,
    String? residencyCount,
    String? approxPeopleCount,
    String? fromTGValues,
    String? toTGValues,
    String? perDayRent,
  }) {
    return ApartmentFormState(
      apartmentId: apartmentId ?? this.apartmentId,
      apartmentName: apartmentName ?? this.apartmentName,
      city: city ?? this.city,
      state: state ?? this.state,
      location: location ?? this.location,
      jioLocation: jioLocation ?? this.jioLocation,
      contactPersonPhone: contactPersonPhone ?? this.contactPersonPhone,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      upiId: upiId ?? this.upiId,
      rating: rating ?? this.rating,
      residencyCount: residencyCount ?? this.residencyCount,
      approxPeopleCount: approxPeopleCount ?? this.approxPeopleCount,
      fromTGValues: fromTGValues ?? this.fromTGValues,
      toTGValues: toTGValues ?? this.toTGValues,
      perDayRent: perDayRent ?? this.perDayRent,
    );
  }
}

class ApartmentFormNotifier extends StateNotifier<ApartmentFormState> {
  ApartmentFormNotifier(this._apiService) : super(const ApartmentFormState());

  final ApiService _apiService;

  void updateApartmentName(String value) {
    state = state.copyWith(apartmentName: value);
  }

  void updateStateName(String value) {
    state = state.copyWith(state: value);
  }

  void updateCity(String value) {
    state = state.copyWith(city: value);
  }

  void updateLocation(String value) {
    state = state.copyWith(location: value);
  }

  void updateJioLocation(String value) {
    state = state.copyWith(jioLocation: value);
  }

  void updateContactPhone(String value) {
    state = state.copyWith(contactPersonPhone: value);
  }

  void updateAccountHolder(String value) {
    state = state.copyWith(accountHolderName: value);
  }

  void updateBankName(String value) {
    state = state.copyWith(bankName: value);
  }

  void updateAccountNumber(String value) {
    state = state.copyWith(accountNumber: value);
  }

  void updateIfscCode(String value) {
    state = state.copyWith(ifscCode: value);
  }

  void updatePhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void updateUpiId(String value) {
    state = state.copyWith(upiId: value);
  }

  void updateRating(String value) {
    state = state.copyWith(rating: value);
  }

  void updateResidencyCount(String value) {
    state = state.copyWith(residencyCount: value);
  }

  void updateApproxPeople(String value) {
    state = state.copyWith(approxPeopleCount: value);
  }

  void updateFromTG(String value) {
    state = state.copyWith(fromTGValues: value);
  }

  void updateToTG(String value) {
    state = state.copyWith(toTGValues: value);
  }

  void updatePerDayRent(String value) {
    state = state.copyWith(perDayRent: value);
  }

  Future<void> saveApartment() async {

    final body = {
      "apartmentName": state.apartmentName,
      "city": state.city,
      "location": state.location,
      "state": state.state,
      "jioLocation": state.jioLocation,
      "contactPersonPhone": state.contactPersonPhone,
      "accountHolderName": state.accountHolderName,
      "bankName": state.bankName,
      "accountNumber": state.accountNumber,
      "ifscCode": state.ifscCode,
      "phoneNumber": state.phoneNumber,
      "upiId": state.upiId,
      "rating": state.rating,
      "residencyCount": int.tryParse(state.residencyCount) ?? 0,
      "approxPeopleCount": int.tryParse(state.approxPeopleCount) ?? 0,
      "fromTGValues": int.tryParse(state.fromTGValues) ?? 0,
      "toTGValues": int.tryParse(state.toTGValues) ?? 0,
      "perDayRent": int.tryParse(state.perDayRent) ?? 0,
    };

    if (state.apartmentId.isNotEmpty) {
      body["apartmentId"] = state.apartmentId;
    }
    await _apiService.saveApartment(body: body);
  }

  void resetForm() {
    state = const ApartmentFormState();
  }

  void loadApartment(Apartment apartment) {
    state = state.copyWith(
      apartmentId: apartment.id ?? '',
      apartmentName: apartment.apartmentName ?? '',
      city: apartment.city ?? '',
      location: apartment.location ?? '',
      state: apartment.state ?? '',
      jioLocation: apartment.jioLocation ?? '',
      contactPersonPhone: apartment.contactPersonPhone ?? '',
      accountHolderName: apartment.bankDetails?.accountName ?? '',
      bankName: apartment.bankDetails?.bankName ?? '',
      accountNumber: apartment.bankDetails?.accountNumber ?? '',
      ifscCode: apartment.bankDetails?.ifscCode ?? '',
      phoneNumber: apartment.bankDetails?.phoneNumber ?? '',
      upiId: apartment.bankDetails?.upiId ?? '',
      rating: apartment.rating?.toString() ?? '',
      residencyCount: apartment.residencyCount?.toString() ?? '',
      approxPeopleCount: apartment.approxPeopleCount?.toString() ?? '',
      fromTGValues: apartment.fromTGValues?.toString() ?? '',
      toTGValues: apartment.toTGValues?.toString() ?? '',
      perDayRent: apartment.perDayRent?.toString() ?? '',
    );
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});
final apartmentFormProvider =
    StateNotifierProvider<ApartmentFormNotifier, ApartmentFormState>((ref) {
      return ApartmentFormNotifier(ref.read(apiServiceProvider));
    });
