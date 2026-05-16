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
  String? updatedBy;
  String? sessionId;
  String? fileName;
  String? uploadedAt;
  int? insertedCount;
  int? updatedCount;
  int? skippedCount;
  int? totalRows;
  List<String>? locationFilter;
  List<String>? cityFilter;
  List<Apartment>? apartments;

  Datas({
    this.pageNumber,
    this.count,
    this.totalCount,
    this.totalPages,
    this.updatedBy,
    this.sessionId,
    this.fileName,
    this.uploadedAt,
    this.insertedCount,
    this.updatedCount,
    this.skippedCount,
    this.totalRows,
    this.locationFilter,
    this.cityFilter,
    this.apartments,
  });

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
    pageNumber: json["pageNumber"],
    count: json["count"],
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    updatedBy: json["updatedBy"],
    sessionId: json["sessionId"],
    fileName: json["fileName"],
    uploadedAt: json["uploadedAt"],
    insertedCount: json["insertedCount"],
    updatedCount: json["updatedCount"],
    skippedCount: json["skippedCount"],
    totalRows: json["totalRows"],
    locationFilter: json["locationFilter"] == null
        ? []
        : List<String>.from(json["locationFilter"]!.map((x) => x)),
    cityFilter: json["cityFilter"] == null
        ? []
        : List<String>.from(json["cityFilter"]!.map((x) => x)),
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
    "updatedBy": updatedBy,
    "sessionId": sessionId,
    "fileName": fileName,
    "uploadedAt": uploadedAt,
    "insertedCount": insertedCount,
    "updatedCount": updatedCount,
    "skippedCount": skippedCount,
    "totalRows": totalRows,
    "locationFilter": locationFilter == null
        ? []
        : List<dynamic>.from(locationFilter!.map((x) => x)),
    "cityFilter": cityFilter == null
        ? []
        : List<dynamic>.from(cityFilter!.map((x) => x)),
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
  List<BankDetail>? bankDetails;
  String? permissionStatus;
  String? rating;
  int? residencyCount;
  int? approxPeopleCount;
  int? startingTgValues;
  List<ExistingEventsHistory>? existingEventsHistory;
  int? perDayRent;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? status;

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
    this.startingTgValues,
    this.existingEventsHistory,
    this.perDayRent,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.status,
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
        ? []
        : List<BankDetail>.from(
            json["bankDetails"]!.map((x) => BankDetail.fromJson(x)),
          ),
    permissionStatus: json["permissionStatus"],
    rating: json["rating"],
    residencyCount: json["residencyCount"],
    approxPeopleCount: json["approxPeopleCount"],
    startingTgValues: json["startingTGValues"],
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
    status: json["status"],
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
    "bankDetails": bankDetails == null
        ? []
        : List<dynamic>.from(bankDetails!.map((x) => x.toJson())),
    "permissionStatus": permissionStatus,
    "rating": rating,
    "residencyCount": residencyCount,
    "approxPeopleCount": approxPeopleCount,
    "startingTGValues": startingTgValues,
    "existingEventsHistory": existingEventsHistory == null
        ? []
        : List<dynamic>.from(existingEventsHistory!.map((x) => x.toJson())),
    "perDayRent": perDayRent,
    "updatedBy": updatedBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "status": status,
  };
}

class BankDetail {
  String? accountName;
  String? bankName;
  String? accountNumber;
  String? ifscCode;
  String? phoneNumber;
  String? upiId;
  String? id;

  BankDetail({
    this.accountName,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.phoneNumber,
    this.upiId,
    this.id,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
    accountName: json["accountName"],
    bankName: json["bankName"],
    accountNumber: json["accountNumber"],
    ifscCode: json["ifscCode"],
    phoneNumber: json["phoneNumber"],
    upiId: json["upiId"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "accountName": accountName,
    "bankName": bankName,
    "accountNumber": accountNumber,
    "ifscCode": ifscCode,
    "phoneNumber": phoneNumber,
    "upiId": upiId,
    "_id": id,
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
