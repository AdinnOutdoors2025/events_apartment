class OrderDetailsModel {
  bool? success;
  int? statusCode;
  String? message;
  OrderDetails? data;

  OrderDetailsModel({this.success, this.statusCode, this.message, this.data});

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : OrderDetails.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "statusCode": statusCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class OrderDetails {
  String? id;
  int? stageRequired;
  List<Item>? items;
  List<Gift>? gifts;
  int? itemsTotal;
  int? giftsTotal;
  int? itemsAndGiftsTotal;
  String? orderId;
  ApartmentId? apartmentId;
  Event? eventId;
  ApartmentDetails? apartmentDetails;
  Event? eventDetails;
  DateTime? fromDate;
  DateTime? toDate;
  int? daysOfEvent;
  List<DailySchedule>? dailySchedule;
  int? promoterRequired;
  int? promoterCount;
  List<Promoter>? promoters;
  CustomerDetails? customerDetails;
  int? discountType;
  int? discountPercentage;
  int? finalAmount;
  int? sqfet;
  int? apartmentAmount;
  int? eventAmount;
  int? promoterTotal;
  int? subTotal;
  int? discountAmount;
  int? taxableAmount;
  int? gstAmount;
  int? totalAmount;
  int? finalDiscoundAmount;
  int? orderStatus;
  List<String>? additionalNotes;
  String? closeLossReason;
  //OrderNote? orderNote;
  List<OrderHistory>? orderHistory;
  bool? isMailSent;
  dynamic mailSentAt;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? orderStatusText;

  OrderDetails({
    this.id,
    this.stageRequired,
    this.items,
    this.gifts,
    this.itemsTotal,
    this.giftsTotal,
    this.itemsAndGiftsTotal,
    this.orderId,
    this.apartmentId,
    this.eventId,
    this.apartmentDetails,
    this.eventDetails,
    this.fromDate,
    this.toDate,
    this.daysOfEvent,
    this.dailySchedule,
    this.promoterRequired,
    this.promoterCount,
    this.promoters,
    this.customerDetails,
    this.discountType,
    this.discountPercentage,
    this.finalAmount,
    this.sqfet,
    this.apartmentAmount,
    this.eventAmount,
    this.promoterTotal,
    this.subTotal,
    this.discountAmount,
    this.taxableAmount,
    this.gstAmount,
    this.totalAmount,
    this.finalDiscoundAmount,
    this.orderStatus,
    this.additionalNotes,
    this.closeLossReason,
   // this.orderNote,
    this.orderHistory,
    this.isMailSent,
    this.mailSentAt,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.orderStatusText,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    id: json["_id"],
    stageRequired: json["stageRequired"],
    items: json["items"] == null
        ? []
        : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
    gifts: json["gifts"] == null
        ? []
        : List<Gift>.from(json["gifts"]!.map((x) => Gift.fromJson(x))),
    itemsTotal: json["items_total"],
    giftsTotal: json["gifts_total"],
    itemsAndGiftsTotal: json["itemsAndGiftsTotal"],
    orderId: json["orderId"],
    apartmentId: json["apartmentId"] == null
        ? null
        : ApartmentId.fromJson(json["apartmentId"]),
    eventId: json["eventId"] == null ? null : Event.fromJson(json["eventId"]),
    apartmentDetails: json["apartmentDetails"] == null
        ? null
        : ApartmentDetails.fromJson(json["apartmentDetails"]),
    eventDetails: json["eventDetails"] == null
        ? null
        : Event.fromJson(json["eventDetails"]),
    fromDate: json["fromDate"] == null
        ? null
        : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
    daysOfEvent: json["daysOfEvent"],
    dailySchedule: json["dailySchedule"] == null
        ? []
        : List<DailySchedule>.from(
            json["dailySchedule"]!.map((x) => DailySchedule.fromJson(x)),
          ),
    promoterRequired: json["promoterRequired"],
    promoterCount: json["promoterCount"],
    promoters: json["promoters"] == null
        ? []
        : List<Promoter>.from(
            json["promoters"]!.map((x) => Promoter.fromJson(x)),
          ),
    customerDetails: json["customerDetails"] == null
        ? null
        : CustomerDetails.fromJson(json["customerDetails"]),
    discountType: json["discountType"],
    discountPercentage: json["discountPercentage"],
    finalAmount: json["finalAmount"],
    sqfet: json["sqfet"],
    apartmentAmount: json["apartmentAmount"],
    eventAmount: json["eventAmount"],
    promoterTotal: json["promoterTotal"],
    subTotal: json["subTotal"],
    discountAmount: json["discountAmount"],
    taxableAmount: json["taxableAmount"],
    gstAmount: json["gstAmount"],
    totalAmount: json["totalAmount"],
    finalDiscoundAmount: json["finalDiscoundAmount"],
    orderStatus: json["orderStatus"],
    additionalNotes: json["additionalNotes"] == null
        ? []
        : List<String>.from(json["additionalNotes"]!.map((x) => x)),
    closeLossReason: json["closeLossReason"],
    /*orderNote: json["orderNote"] == null
        ? null
        : OrderNote.fromJson(json["orderNote"]),*/
    orderHistory: json["orderHistory"] == null
        ? []
        : List<OrderHistory>.from(
            json["orderHistory"]!.map((x) => OrderHistory.fromJson(x)),
          ),
    isMailSent: json["isMailSent"],
    mailSentAt: json["mailSentAt"],
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    orderStatusText: json["orderStatusText"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "stageRequired": stageRequired,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "gifts": gifts == null
        ? []
        : List<dynamic>.from(gifts!.map((x) => x.toJson())),
    "items_total": itemsTotal,
    "gifts_total": giftsTotal,
    "itemsAndGiftsTotal": itemsAndGiftsTotal,
    "orderId": orderId,
    "apartmentId": apartmentId?.toJson(),
    "eventId": eventId?.toJson(),
    "apartmentDetails": apartmentDetails?.toJson(),
    "eventDetails": eventDetails?.toJson(),
    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
    "daysOfEvent": daysOfEvent,
    "dailySchedule": dailySchedule == null
        ? []
        : List<dynamic>.from(dailySchedule!.map((x) => x.toJson())),
    "promoterRequired": promoterRequired,
    "promoterCount": promoterCount,
    "promoters": promoters == null
        ? []
        : List<dynamic>.from(promoters!.map((x) => x.toJson())),
    "customerDetails": customerDetails?.toJson(),
    "discountType": discountType,
    "discountPercentage": discountPercentage,
    "finalAmount": finalAmount,
    "sqfet": sqfet,
    "apartmentAmount": apartmentAmount,
    "eventAmount": eventAmount,
    "promoterTotal": promoterTotal,
    "subTotal": subTotal,
    "discountAmount": discountAmount,
    "taxableAmount": taxableAmount,
    "gstAmount": gstAmount,
    "totalAmount": totalAmount,
    "finalDiscoundAmount": finalDiscoundAmount,
    "orderStatus": orderStatus,
    "additionalNotes": additionalNotes == null
        ? []
        : List<dynamic>.from(additionalNotes!.map((x) => x)),
    "closeLossReason": closeLossReason,
   // "orderNote": orderNote?.toJson(),
    "orderHistory": orderHistory == null
        ? []
        : List<dynamic>.from(orderHistory!.map((x) => x.toJson())),
    "isMailSent": isMailSent,
    "mailSentAt": mailSentAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "orderStatusText": orderStatusText,
  };
}

class ApartmentDetails {
  String? id;
  String? apartmentName;
  String? city;
  String? location;
  int? perDayRent;
  String? contactPersonName;
  String? contactPersonPhone;

  ApartmentDetails({
    this.id,
    this.apartmentName,
    this.city,
    this.location,
    this.perDayRent,
    this.contactPersonName,
    this.contactPersonPhone,
  });

  factory ApartmentDetails.fromJson(Map<String, dynamic> json) =>
      ApartmentDetails(
        id: json["_id"],
        apartmentName: json["apartmentName"],
        city: json["city"],
        location: json["location"],
        perDayRent: json["perDayRent"],
        contactPersonName: json["contactPersonName"],
        contactPersonPhone: json["contactPersonPhone"],
      );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "apartmentName": apartmentName,
    "city": city,
    "location": location,
    "perDayRent": perDayRent,
    "contactPersonName": contactPersonName,
    "contactPersonPhone": contactPersonPhone,
  };
}

class ApartmentId {
  String? id;

  ApartmentId({this.id});

  factory ApartmentId.fromJson(Map<String, dynamic> json) =>
      ApartmentId(id: json["_id"]);

  Map<String, dynamic> toJson() => {"_id": id};
}

class CustomerDetails {
  int? customerType;
  String? gstNumber;
  String? designation;
  String? brandOrCompanyName;
  String? contactPersonName;
  String? contactPersonPhoneNumber;
  String? email;
  String? customerAdditionalNotes;
  String? customerId;

  CustomerDetails({
    this.customerType,
    this.gstNumber,
    this.designation,
    this.brandOrCompanyName,
    this.contactPersonName,
    this.contactPersonPhoneNumber,
    this.email,
    this.customerAdditionalNotes,
    this.customerId,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) =>
      CustomerDetails(
        customerType: json["customerType"],
        gstNumber: json["gstNumber"],
        designation: json["designation"],
        brandOrCompanyName: json["brandOrCompanyName"],
        contactPersonName: json["contactPersonName"],
        contactPersonPhoneNumber: json["contactPersonPhoneNumber"],
        email: json["email"],
        customerAdditionalNotes: json["customerAdditionalNotes"],
        customerId: json["_customerId"],
      );

  Map<String, dynamic> toJson() => {
    "customerType": customerType,
    "gstNumber": gstNumber,
    "designation": designation,
    "brandOrCompanyName": brandOrCompanyName,
    "contactPersonName": contactPersonName,
    "contactPersonPhoneNumber": contactPersonPhoneNumber,
    "email": email,
    "customerAdditionalNotes": customerAdditionalNotes,
    "_customerId": customerId,
  };
}

class DailySchedule {
  //int? days;
  String? fromTime;
  String? toTime;
  String? notes;

  DailySchedule({
    // this.days,
    this.fromTime,
    this.toTime,
    this.notes,
  });

  factory DailySchedule.fromJson(Map<String, dynamic> json) => DailySchedule(
    // days: json["days"],
    fromTime: json["fromTime"],
    toTime: json["toTime"],
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    // "days": days,
    "fromTime": fromTime,
    "toTime": toTime,
    "notes": notes,
  };
}

class Event {
  String? id;
  String? eventName;
  int? amount;

  Event({this.id, this.eventName, this.amount});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["_id"],
    eventName: json["eventName"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "eventName": eventName,
    "amount": amount,
  };
}

class Gift {
  String? giftId;
  String? giftName;
  int? giftType;
  int? quantity;
  int? unitPrice;
  int? priceType;
  int? giftAmount;

  Gift({
    this.giftId,
    this.giftName,
    this.giftType,
    this.quantity,
    this.unitPrice,
    this.priceType,
    this.giftAmount,
  });

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
    giftId: json["gift_id"],
    giftName: json["gift_name"],
    giftType: json["gift_type"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    priceType: json["price_type"],
    giftAmount: json["gift_amount"],
  );

  Map<String, dynamic> toJson() => {
    "gift_id": giftId,
    "gift_name": giftName,
    "gift_type": giftType,
    "quantity": quantity,
    "unit_price": unitPrice,
    "price_type": priceType,
    "gift_amount": giftAmount,
  };
}

class Item {
  String? itemId;
  String? state;
  String? itemName;
  int? itemType;
  int? quantity;
  int? unitAmount;
  int? amountUnit;
  int? itemAmount;

  Item({
    this.itemId,
    this.state,
    this.itemName,
    this.itemType,
    this.quantity,
    this.unitAmount,
    this.amountUnit,
    this.itemAmount,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemId: json["item_id"],
    state: json["state"],
    itemName: json["item_name"],
    itemType: json["item_type"],
    quantity: json["quantity"],
    unitAmount: json["unit_amount"],
    amountUnit: json["amount_unit"],
    itemAmount: json["item_amount"],
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "state": state,
    "item_name": itemName,
    "item_type": itemType,
    "quantity": quantity,
    "unit_amount": unitAmount,
    "amount_unit": amountUnit,
    "item_amount": itemAmount,
  };
}

class OrderHistory {
  int? fromStatus;
  String? fromStatusText;
  int? toStatus;
  String? toStatusText;
  String? changedBy;
  DateTime? changedAt;
  List<AdditionalNote>? additionalNotes;
  List<dynamic>? poDocument;
  List<StatusDocument>? statusDocument;
  List<StatusDocument>? voiceDocument;

  OrderHistory({
    this.fromStatus,
    this.fromStatusText,
    this.toStatus,
    this.toStatusText,
    this.changedBy,
    this.changedAt,
    this.additionalNotes,
    this.poDocument,
    this.statusDocument,
    this.voiceDocument,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
    fromStatus: json["fromStatus"],
    fromStatusText: json["fromStatusText"],
    toStatus: json["toStatus"],
    toStatusText: json["toStatusText"],
    changedBy: json["changedBy"],
    changedAt: json["changedAt"] == null
        ? null
        : DateTime.parse(json["changedAt"]),
    additionalNotes: json["additionalNotes"] == null
        ? []
        : List<AdditionalNote>.from(
      json["additionalNotes"]!.map((x) => AdditionalNote.fromJson(x)),
    ),
    poDocument: json["poDocument"] == null
        ? []
        : List<dynamic>.from(json["poDocument"]!.map((x) => x)),
    statusDocument: json["statusDocument"] == null
        ? []
        : List<StatusDocument>.from(
            json["statusDocument"]!.map((x) => StatusDocument.fromJson(x)),
          ),
    voiceDocument: json["voiceDocument"] == null
        ? []
        : List<StatusDocument>.from(
      json["voiceDocument"]!.map((x) => StatusDocument.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "fromStatus": fromStatus,
    "fromStatusText": fromStatusText,
    "toStatus": toStatus,
    "toStatusText": toStatusText,
    "changedBy": changedBy,
    "changedAt": changedAt?.toIso8601String(),
    "additionalNotes": additionalNotes == null
        ? []
        : List<dynamic>.from(additionalNotes!.map((x) => x.toJson())),
    "poDocument": poDocument == null
        ? []
        : List<dynamic>.from(poDocument!.map((x) => x)),
    "statusDocument": statusDocument == null
        ? []
        : List<dynamic>.from(statusDocument!.map((x) => x.toJson())),
    "voiceDocument": voiceDocument == null
        ? []
        : List<dynamic>.from(voiceDocument!.map((x) => x.toJson())),
  };
}
class AdditionalNote {
  String? text;
  String? uploadedBy;
  DateTime? uploadedAt;

  AdditionalNote({
    this.text,
    this.uploadedBy,
    this.uploadedAt,
  });

  factory AdditionalNote.fromJson(dynamic json) {
    if (json is String) {
      return AdditionalNote(text: json);
    }

    return AdditionalNote(
      text: json["text"],
      uploadedBy: json["uploadedBy"],
      uploadedAt: json["uploadedAt"] == null
          ? null
          : DateTime.parse(json["uploadedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "text": text,
    "uploadedBy": uploadedBy,
    "uploadedAt": uploadedAt?.toIso8601String(),
  };
}

class StatusDocument {
  String? originalName;
  String? fileName;
  String? filePath;
  String? mimeType;
  int? size;
  String? fileType;
  DateTime? uploadedAt;
  String? duration;
  double? durationInSeconds;
  String? uploadedBy;

  StatusDocument({
    this.originalName,
    this.fileName,
    this.filePath,
    this.mimeType,
    this.size,
    this.fileType,
    this.uploadedAt,
    this.duration,
    this.durationInSeconds,
    this.uploadedBy,
  });

  factory StatusDocument.fromJson(Map<String, dynamic> json) => StatusDocument(
    originalName: json["originalName"],
    fileName: json["fileName"],
    filePath: json["filePath"],
    mimeType: json["mimeType"],
    size: json["size"],
    fileType: json["fileType"],
    duration: json["duration"],
    durationInSeconds: json["durationInSeconds"] == null
        ? null
        : double.tryParse(json["durationInSeconds"].toString()),
    uploadedAt: json["uploadedAt"] == null
        ? null
        : DateTime.parse(json["uploadedAt"]),
    uploadedBy: json["uploadedBy"],
  );

  Map<String, dynamic> toJson() => {
    "originalName": originalName,
    "fileName": fileName,
    "filePath": filePath,
    "mimeType": mimeType,
    "size": size,
    "duration": duration,
    "durationInSeconds": durationInSeconds,
    "fileType": fileType,
    "uploadedAt": uploadedAt?.toIso8601String(),
    "uploadedBy": uploadedBy,
  };
}

class OrderNote {
  String? text;
  List<dynamic>? files;

  OrderNote({this.text, this.files});

  factory OrderNote.fromJson(Map<String, dynamic> json) => OrderNote(
    text: json["text"],
    files: json["files"] == null
        ? []
        : List<dynamic>.from(json["files"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "files": files == null ? [] : List<dynamic>.from(files!.map((x) => x)),
  };
}

class Promoter {
  String? promoterGender;
  int? promoterDays;
  int? promoterPerDayCharge;
  List<String>? promoterLanguage;
  List<String>? promoterLookAndAppearance;
  int? promoterAmount;
  String? promoterNotes;
  String? promoterId;

  Promoter({
    this.promoterGender,
    this.promoterDays,
    this.promoterPerDayCharge,
    this.promoterLanguage,
    this.promoterLookAndAppearance,
    this.promoterAmount,
    this.promoterNotes,
    this.promoterId,
  });

  factory Promoter.fromJson(Map<String, dynamic> json) => Promoter(
    promoterGender: json["promoterGender"],
    promoterDays: json["promoterDays"],
    promoterPerDayCharge: json["promoterPerDayCharge"],
    promoterLanguage: json["promoterLanguage"] == null
        ? []
        : List<String>.from(json["promoterLanguage"]!.map((x) => x)),
    promoterLookAndAppearance: json["promoterLookAndAppearance"] == null
        ? []
        : List<String>.from(json["promoterLookAndAppearance"]!.map((x) => x)),
    promoterAmount: json["promoterAmount"],
    promoterNotes: json["promoterNotes"],
    promoterId: json["_promoterId"],
  );

  Map<String, dynamic> toJson() => {
    "promoterGender": promoterGender,
    "promoterDays": promoterDays,
    "promoterPerDayCharge": promoterPerDayCharge,
    "promoterLanguage": promoterLanguage == null
        ? []
        : List<dynamic>.from(promoterLanguage!.map((x) => x)),
    "promoterLookAndAppearance": promoterLookAndAppearance == null
        ? []
        : List<dynamic>.from(promoterLookAndAppearance!.map((x) => x)),
    "promoterAmount": promoterAmount,
    "promoterNotes": promoterNotes,
    "_promoterId": promoterId,
  };
}
