class GetListModel {
  bool? success;
  String? message;
  Datas? data;

  GetListModel({this.success, this.message, this.data});

  factory GetListModel.fromJson(Map<String, dynamic> json) => GetListModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Datas.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Datas {
  int? pageNumber;
  int? count;
  int? totalCount;
  int? totalPages;
  LatestFile? file;
  List<String>? locationFilter;
  List<String>? cityFilter;
  PriceRange? priceRange;
  List<Apartment>? apartments;

  Datas({
    this.pageNumber,
    this.count,
    this.totalCount,
    this.totalPages,
    this.file,
    this.locationFilter,
    this.cityFilter,
    this.priceRange,
    this.apartments,
  });

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
    pageNumber: json["pageNumber"],
    count: json["count"],
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    file: json["file"] == null ? null : LatestFile.fromJson(json["file"]),
    locationFilter: json["locationFilter"] == null
        ? []
        : List<String>.from(json["locationFilter"]!.map((x) => x)),
    cityFilter: json["cityFilter"] == null
        ? []
        : List<String>.from(json["cityFilter"]!.map((x) => x)),
    priceRange: json["priceRange"] == null
        ? null
        : PriceRange.fromJson(json["priceRange"]),
    apartments: json["apartments"] == null
        ? []
        : List<Apartment>.from(
            json["apartments"]!.map((x) => Apartment.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "count": count,
    "totalCount": totalCount,
    "totalPages": totalPages,
    "file": file?.toJson(),
    "locationFilter": locationFilter == null
        ? []
        : List<dynamic>.from(locationFilter!.map((x) => x)),
    "cityFilter": cityFilter == null
        ? []
        : List<dynamic>.from(cityFilter!.map((x) => x)),
    "priceRange": priceRange?.toJson(),
    "apartments": apartments == null
        ? []
        : List<dynamic>.from(apartments!.map((x) => x.toJson())),
  };
}

class Apartment {
  String? id;
  String? apartmentId;
  AtedBySession? createdBySession;
  AtedBySession? lastUpdatedBySession;
  String? apartmentName;
  String? apartmentAddress;
  String? city;
  String? location;
  String? jioLocation;
  String? photo;
  String? apartmentSummary;
  String? contactPersonName;
  String? contactPersonPhone;
  String? email;
  BankDetail? bankDetails;
  String? permissionStatus;
  String? rating;
  int? residencyCount;
  int? approxPeopleCount;
  int? fromTGValues;
  int? toTGValues;
  List<ExistingEventsHistory>? existingEventsHistory;
  String? perDayRent;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? sessionStatus;

  Apartment({
    this.id,
    this.apartmentId,
    this.createdBySession,
    this.lastUpdatedBySession,
    this.apartmentName,
    this.apartmentAddress,
    this.city,
    this.location,
    this.jioLocation,
    this.photo,
    this.apartmentSummary,
    this.contactPersonName,
    this.contactPersonPhone,
    this.email,
    this.bankDetails,
    this.permissionStatus,
    this.rating,
    this.residencyCount,
    this.approxPeopleCount,
    this.fromTGValues,
    this.toTGValues,
    this.existingEventsHistory,
    this.perDayRent,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.sessionStatus,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
    id: json["_id"],
    apartmentId: json["apartmentId"],
    createdBySession: json["createdBySession"] == null
        ? null
        : AtedBySession.fromJson(json["createdBySession"]),
    lastUpdatedBySession: json["lastUpdatedBySession"] == null
        ? null
        : AtedBySession.fromJson(json["lastUpdatedBySession"]),
    apartmentName: json["apartmentName"],
    apartmentAddress: json["apartmentAddress"],
    city: json["city"],
    location: json["location"],
    jioLocation: json["jioLocation"],
    photo: json["photo"],
    apartmentSummary: json["apartmentSummary"],
    contactPersonName: json["contactPersonName"],
    contactPersonPhone: json["contactPersonPhone"],
    email: json["email"],
    bankDetails: json["bankDetails"] == null
        ? null
        : BankDetail.fromJson(json["bankDetails"]),
    permissionStatus: json["permissionStatus"],
    rating: json["rating"],
    residencyCount: json["residencyCount"],
    approxPeopleCount: json["approxPeopleCount"],
    fromTGValues: json["fromTGValues"],
    toTGValues: json["toTGValues"],
    existingEventsHistory: json["existingEventsHistory"] == null
        ? []
        : List<ExistingEventsHistory>.from(
            json["existingEventsHistory"]!.map(
              (x) => ExistingEventsHistory.fromJson(x),
            ),
          ),
    perDayRent: json["perDayRent"],
    updatedBy: json["updatedBy"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    sessionStatus: json["sessionStatus"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "apartmentId": apartmentId,
    "createdBySession": createdBySession?.toJson(),
    "lastUpdatedBySession": lastUpdatedBySession?.toJson(),
    "apartmentName": apartmentName,
    "apartmentAddress": apartmentAddress,
    "city": city,
    "location": location,
    "jioLocation": jioLocation,
    "photo": photo,
    "apartmentSummary": apartmentSummary,
    "contactPersonName": contactPersonName,
    "contactPersonPhone": contactPersonPhone,
    "email": email,
    "bankDetails": bankDetails?.toJson(),
    "permissionStatus": permissionStatus,
    "rating": rating,
    "residencyCount": residencyCount,
    "approxPeopleCount": approxPeopleCount,
    "fromTGValues": fromTGValues,
    "toTGValues": toTGValues,
    "existingEventsHistory": existingEventsHistory == null
        ? []
        : List<dynamic>.from(existingEventsHistory!.map((x) => x.toJson())),
    "perDayRent": perDayRent,
    "updatedBy": updatedBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "sessionStatus": sessionStatus,
  };
}

class PriceRange {
  int? minTG;
  int? maxTG;
  int? minRent;
  int? maxRent;

  PriceRange({this.minTG, this.maxTG, this.minRent, this.maxRent});

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
    minTG: json["minTG"],
    maxTG: json["maxTG"],
    minRent: json["minRent"],
    maxRent: json["maxRent"],
  );

  Map<String, dynamic> toJson() => {
    "minTG": minTG,
    "maxTG": maxTG,
    "minRent": minRent,
    "maxRent": maxRent,
  };
}

class BankDetail {
  String? accountName;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? phoneNumber;
  String? upiId;

  BankDetail({
    this.accountName,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.phoneNumber,
    this.upiId,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
    accountName: json["accountHolderName"],
    bankName: json["bankName"],
    accountNumber: json["accountNumber"],
    ifscCode: json["ifscCode"],
    phoneNumber: json["phoneNumber"],
    upiId: json["upiId"],
  );

  Map<String, dynamic> toJson() => {
    "accountHolderName": accountName,
    "bankName": bankName,
    "accountNumber": accountNumber,
    "ifscCode": ifscCode,
    "phoneNumber": phoneNumber,
    "upiId": upiId,
  };
}

class AtedBySession {
  String? id;
  String? fileName;
  DateTime? createdAt;

  AtedBySession({this.id, this.fileName, this.createdAt});

  factory AtedBySession.fromJson(Map<String, dynamic> json) => AtedBySession(
    id: json["_id"],
    fileName: json["fileName"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fileName": fileName,
    "createdAt": createdAt?.toIso8601String(),
  };
}

class ExistingEventsHistory {
  String? eventName;
  String? eventDate;
  String? remarks;
  String? id;

  ExistingEventsHistory({
    this.eventName,
    this.eventDate,
    this.remarks,
    this.id,
  });

  factory ExistingEventsHistory.fromJson(Map<String, dynamic> json) =>
      ExistingEventsHistory(
        eventName: json["eventName"],
        eventDate: json["eventDate"],
        remarks: json["remarks"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
    "eventName": eventName,
    "eventDate": eventDate,
    "remarks": remarks,
    "_id": id,
  };
}

class LatestFile {
  String? sessionId;
  String? fileName;
  int? totalRows;
  int? insertedCount;
  int? updatedCount;
  int? skippedCount;
  DateTime? uploadedAt;

  LatestFile({
    this.sessionId,
    this.fileName,
    this.totalRows,
    this.insertedCount,
    this.updatedCount,
    this.skippedCount,
    this.uploadedAt,
  });

  factory LatestFile.fromJson(Map<String, dynamic> json) => LatestFile(
    sessionId: json["sessionId"],
    fileName: json["fileName"],
    totalRows: json["totalRows"],
    insertedCount: json["insertedCount"],
    updatedCount: json["updatedCount"],
    skippedCount: json["skippedCount"],
    uploadedAt: json["uploadedAt"] == null
        ? null
        : DateTime.parse(json["uploadedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "fileName": fileName,
    "totalRows": totalRows,
    "insertedCount": insertedCount,
    "updatedCount": updatedCount,
    "skippedCount": skippedCount,
    "uploadedAt": uploadedAt?.toIso8601String(),
  };
}
