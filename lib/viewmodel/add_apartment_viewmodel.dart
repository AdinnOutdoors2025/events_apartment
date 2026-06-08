import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/get_list_model.dart';
import '../services/api_service.dart';

class ApartmentFormState {
  final String apartmentId;
  final String apartmentGroupName;
  final String apartmentName;
  final String city;
  final String state;
  final String location;
  final String jioLocation;
  final String contactPersonPhone;
  final String contactPersonName;
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
  final int? perDayRent;

  const ApartmentFormState({
    this.apartmentId = '',
    this.apartmentGroupName = '',
    this.apartmentName = '',
    this.city = '',
    this.state = '',
    this.location = '',
    this.jioLocation = '',
    this.contactPersonPhone = '',
    this.contactPersonName = '-',
    this.accountHolderName = '',
    this.bankName = '-',
    this.accountNumber = '',
    this.ifscCode = '',
    this.phoneNumber = '',
    this.upiId = '',
    this.rating = '',
    this.residencyCount = '',
    this.approxPeopleCount = '',
    this.fromTGValues = '',
    this.toTGValues = '',
    this.perDayRent = 0,
  });

  ApartmentFormState copyWith({
    String? apartmentId,
    String? apartmentGroupName,
    String? apartmentName,
    String? city,
    String? state,
    String? location,
    String? jioLocation,
    String? contactPersonPhone,
    String? contactPersonName,
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
    int? perDayRent,
  }) {
    return ApartmentFormState(
      apartmentId: apartmentId ?? this.apartmentId,
      apartmentGroupName: apartmentGroupName ?? this.apartmentGroupName,
      apartmentName: apartmentName ?? this.apartmentName,
      city: city ?? this.city,
      state: state ?? this.state,
      location: location ?? this.location,
      jioLocation: jioLocation ?? this.jioLocation,
      contactPersonPhone: contactPersonPhone ?? this.contactPersonPhone,
      contactPersonName: contactPersonName ?? this.contactPersonName,
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

  void updateApartmentGroupName(String value) {
    state = state.copyWith(apartmentGroupName: value);
  }

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

  void updatePersonName(String value) {
    state = state.copyWith(contactPersonName: value);
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
    state = state.copyWith(fromTGValues: value.replaceAll(',', ''));
  }

  void updateToTG(String value) {
    state = state.copyWith(toTGValues: value.replaceAll(',', ''));
  }

  void updatePerDayRent(String value) {
    final cleanedValue = value.replaceAll(',', '');

    state = state.copyWith(perDayRent: int.tryParse(cleanedValue) ?? 0);
  }

  Future<Apartment> saveApartment({required bool isEdit}) async {
    final body = {
      "ApartmentGroupName": state.apartmentGroupName,
      "ApartmentName": state.apartmentName,
      "City": state.city,
      "State": state.state,
      "Location": state.location,
      "GeoLocation": state.jioLocation,
      "ContactPersonPhone": state.contactPersonPhone,
      "ContactPersonName": state.contactPersonName,
      "AccountHolderName": state.accountHolderName,
      "BankName": state.bankName,
      "AccountNumber": state.accountNumber,
      "IfscCode": state.ifscCode,
      "PhoneNumber": state.phoneNumber,
      "UpiID": state.upiId,
      "Rating": state.rating,
      "ResidencyCount":
          int.tryParse(state.residencyCount.replaceAll(',', '')) ?? "",
      "ApproxPeopleCount":
          int.tryParse(state.approxPeopleCount.replaceAll(',', '')) ?? "",
      "FromTGValues":
          int.tryParse(state.fromTGValues.replaceAll(',', '')) ?? "",

      "ToTGValues": int.tryParse(state.toTGValues.replaceAll(',', '')) ?? "",

      "PerDayRent":
          int.tryParse(state.perDayRent.toString().replaceAll(',', '')) ?? "",
    };

    /* if (isEdit && state.apartmentId.isNotEmpty) {
      body["apartmentId"] = state.apartmentId;
    }
    return await _apiService.saveApartment(body: body);*/
    if (isEdit) {
      body["apartmentId"] = state.apartmentId;
    }

    if (kDebugMode) {
      print("SAVE MODE => ${isEdit ? 'EDIT' : 'ADD'}");
      print("APARTMENT ID SENT => ${body["apartmentId"]}");
      print("BODY => $body");
    }

    final apartment = await _apiService.saveApartment(body: body);

    return apartment;
  }

  void resetForm() {
    state = const ApartmentFormState();
  }

  void clearApartmentId() {
    state = state.copyWith(apartmentId: '');
  }

  void loadApartment(Apartment apartment) {
    state = state.copyWith(
      apartmentId: apartment.id ?? '',
      apartmentGroupName: apartment.apartmentGroupName ?? '',
      apartmentName: apartment.apartmentName ?? '',
      city: apartment.city ?? '',
      location: apartment.location ?? '',
      state: apartment.state ?? '',
      jioLocation: apartment.jioLocation ?? '',
      contactPersonPhone: apartment.contactPersonPhone ?? '',
      contactPersonName: apartment.contactPersonName ?? '',
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
      perDayRent: apartment.perDayRent,
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
