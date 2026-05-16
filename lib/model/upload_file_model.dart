class UploadFileModel {
  bool? success;
  String? message;
  Data? data;

  UploadFileModel({this.success, this.message, this.data});

  factory UploadFileModel.fromJson(Map<String, dynamic> json) =>
      UploadFileModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? sessionId;
  String? fileName;
  int? totalRows;
  String? updatedBy;
  int? insertedCount;
  int? updatedCount;
  int? skippedCount;
  List<InsertedDatum>? insertedData;
  List<dynamic>? updatedData;
  List<dynamic>? skippedData;
  Summary? summary;

  Data({
    this.sessionId,
    this.fileName,
    this.totalRows,
    this.updatedBy,
    this.insertedCount,
    this.updatedCount,
    this.skippedCount,
    this.insertedData,
    this.updatedData,
    this.skippedData,
    this.summary,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sessionId: json["sessionId"],
    fileName: json["fileName"],
    totalRows: json["totalRows"],
    updatedBy: json["updatedBy"],
    insertedCount: json["insertedCount"],
    updatedCount: json["updatedCount"],
    skippedCount: json["skippedCount"],
    insertedData: json["insertedData"] == null
        ? []
        : List<InsertedDatum>.from(
            json["insertedData"]!.map((x) => InsertedDatum.fromJson(x)),
          ),
    updatedData: json["updatedData"] == null
        ? []
        : List<dynamic>.from(json["updatedData"]!.map((x) => x)),
    skippedData: json["skippedData"] == null
        ? []
        : List<dynamic>.from(json["skippedData"]!.map((x) => x)),
    summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
  );

  Map<String, dynamic> toJson() => {
    "sessionId": sessionId,
    "fileName": fileName,
    "totalRows": totalRows,
    "updatedBy": updatedBy,
    "insertedCount": insertedCount,
    "updatedCount": updatedCount,
    "skippedCount": skippedCount,
    "insertedData": insertedData == null
        ? []
        : List<dynamic>.from(insertedData!.map((x) => x.toJson())),
    "updatedData": updatedData == null
        ? []
        : List<dynamic>.from(updatedData!.map((x) => x)),
    "skippedData": skippedData == null
        ? []
        : List<dynamic>.from(skippedData!.map((x) => x)),
    "summary": summary?.toJson(),
  };
}

class InsertedDatum {
  String? id;
  String? apartmentId;
  String? message;

  InsertedDatum({this.id, this.apartmentId, this.message});

  factory InsertedDatum.fromJson(Map<String, dynamic> json) => InsertedDatum(
    id: json["id"],
    apartmentId: json["apartmentId"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "apartmentId": apartmentId,
    "message": message,
  };
}

class Summary {
  int? totalInserted;
  int? totalUpdated;
  int? totalSkipped;

  Summary({this.totalInserted, this.totalUpdated, this.totalSkipped});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalInserted: json["totalInserted"],
    totalUpdated: json["totalUpdated"],
    totalSkipped: json["totalSkipped"],
  );

  Map<String, dynamic> toJson() => {
    "totalInserted": totalInserted,
    "totalUpdated": totalUpdated,
    "totalSkipped": totalSkipped,
  };
}

class UploadSummaryData {
  String? fileName;
  int? totalRows;
  int? insertedCount;
  int? updatedCount;
  int? skippedCount;
  String? uploadedAt;

  UploadSummaryData({
    this.fileName,
    this.totalRows,
    this.insertedCount,
    this.updatedCount,
    this.skippedCount,
    this.uploadedAt,
  });
}
