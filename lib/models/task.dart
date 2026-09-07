class Task {
  final String id;
  final String customerName;
  final String customerPhone;
  final String serviceType;
  final String priority;
  final String dateTime;
  final String address;
  String status;
  double? startLatitude;
  double? startLongitude;
  double? completionLatitude;
  double? completionLongitude;
  String notes;
  List<String> images;
  bool customerConfirmed;

  Task({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceType,
    required this.priority,
    required this.dateTime,
    required this.address,
    required this.status,
    this.startLatitude,
    this.startLongitude,
    this.completionLatitude,
    this.completionLongitude,
    this.notes = '',
    List<String>? images,
    this.customerConfirmed = false,
  }) : images = images ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'serviceType': serviceType,
        'priority': priority,
        'dateTime': dateTime,
        'address': address,
        'status': status,
        'startLatitude': startLatitude,
        'startLongitude': startLongitude,
        'completionLatitude': completionLatitude,
        'completionLongitude': completionLongitude,
        'notes': notes,
        'images': images,
        'customerConfirmed': customerConfirmed,
      };
}
