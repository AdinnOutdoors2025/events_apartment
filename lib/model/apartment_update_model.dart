class ApartmentUpdate {
  bool? success;
  String? message;
  ApartmentData? data;

  ApartmentUpdate({
    this.success,
    this.message,
    this.data,
  });

  factory ApartmentUpdate.fromJson(Map<String, dynamic> json) => ApartmentUpdate(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ApartmentData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ApartmentData {
  BankDetails? bankDetails;
  String? id;
  String? createdBySession;
  String? lastUpdatedBySession;
  dynamic skippedBySession;
  String? apartmentName;
  String? apartmentGroupName;
  String? city;
  String? state;
  String? location;
  String? geoLocation;
  String? contactPersonName;
  String? contactPersonPhone;
  String? permissionStatus;
  String? rating;
  int? residencyCount;
  int? approxPeopleCount;
  int? fromTgValues;
  int? toTgValues;
  bool? isActive;
  int? perDayRent;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? apartmentId;
  int? v;

  ApartmentData({
    this.bankDetails,
    this.id,
    this.createdBySession,
    this.lastUpdatedBySession,
    this.skippedBySession,
    this.apartmentName,
    this.apartmentGroupName,
    this.city,
    this.state,
    this.location,
    this.geoLocation,
    this.contactPersonName,
    this.contactPersonPhone,
    this.permissionStatus,
    this.rating,
    this.residencyCount,
    this.approxPeopleCount,
    this.fromTgValues,
    this.toTgValues,
    this.isActive,
    this.perDayRent,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.apartmentId,
    this.v,
  });

  factory ApartmentData.fromJson(Map<String, dynamic> json) => ApartmentData(
    bankDetails: json["bankDetails"] == null ? null : BankDetails.fromJson(json["bankDetails"]),
    id: json["_id"],
    createdBySession: json["createdBySession"],
    lastUpdatedBySession: json["lastUpdatedBySession"],
    skippedBySession: json["skippedBySession"],
    apartmentName: json["ApartmentName"],
    apartmentGroupName: json["ApartmentGroupName"],
    city: json["City"],
    state: json["State"],
    location: json["Location"],
    geoLocation: json["GeoLocation"],
    contactPersonName: json["ContactPersonName"],
    contactPersonPhone: json["ContactPersonPhone"],
    permissionStatus: json["PermissionStatus"],
    rating: json["Rating"],
    residencyCount: json["ResidencyCount"],
    approxPeopleCount: json["ApproxPeopleCount"],
    fromTgValues: json["FromTGValues"],
    toTgValues: json["ToTGValues"],
    isActive: json["isActive"],
    perDayRent: json["PerDayRent"],
    updatedBy: json["updatedBy"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    apartmentId: json["apartmentId"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "bankDetails": bankDetails?.toJson(),
    "_id": id,
    "createdBySession": createdBySession,
    "lastUpdatedBySession": lastUpdatedBySession,
    "skippedBySession": skippedBySession,
    "ApartmentName": apartmentName,
    "ApartmentGroupName": apartmentGroupName,
    "City": city,
    "State": state,
    "Location": location,
    "GeoLocation": geoLocation,
    "ContactPersonName": contactPersonName,
    "ContactPersonPhone": contactPersonPhone,
    "PermissionStatus": permissionStatus,
    "Rating": rating,
    "ResidencyCount": residencyCount,
    "ApproxPeopleCount": approxPeopleCount,
    "FromTGValues": fromTgValues,
    "ToTGValues": toTgValues,
    "isActive": isActive,
    "PerDayRent": perDayRent,
    "updatedBy": updatedBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "apartmentId": apartmentId,
    "__v": v,
  };
}

class BankDetails {
  String? accountHolderName;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? phoneNumber;
  String? upiId;

  BankDetails({
    this.accountHolderName,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.phoneNumber,
    this.upiId,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
    accountHolderName: json["AccountHolderName"],
    bankName: json["BankName"],
    accountNumber: json["AccountNumber"],
    ifscCode: json["IfscCode"],
    phoneNumber: json["PhoneNumber"],
    upiId: json["UpiID"],
  );

  Map<String, dynamic> toJson() => {
    "AccountHolderName": accountHolderName,
    "BankName": bankName,
    "AccountNumber": accountNumber,
    "IfscCode": ifscCode,
    "PhoneNumber": phoneNumber,
    "UpiID": upiId,
  };
}