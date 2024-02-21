class Delivery {
  String id;
  DateTime createDate;
  String status;
  String origin;
  String destination;
  String orderNr;
  int weight;
  String dimensions;
  String type;
  Map<String, dynamic> customerInfo;
  String riderID;
  String? comment;

  Delivery(
      {required this.id,
      required this.createDate,
      required this.status,
      required this.origin,
      required this.destination,
      required this.orderNr,
      required this.weight,
      required this.dimensions,
      required this.type,
      required this.customerInfo,
      required this.riderID,
      this.comment});

  factory Delivery.fromJson(Map<String, dynamic> parsedJson) {
    return Delivery(
      id: parsedJson['id'] ?? "",
      createDate: DateTime.parse(parsedJson['created_at']),
      status: parsedJson['delivery_status'] ?? "",
      origin: parsedJson['origin'] ?? "",
      destination: parsedJson['destination'] ?? 0,
      orderNr: parsedJson['order_nr'] ?? '',
      weight: parsedJson['weight'],
      dimensions: parsedJson['dimensions'] ?? 0,
      type: parsedJson['type'] ?? 0,
      customerInfo: parsedJson['customer_info'] ?? {},
      riderID: parsedJson['rider_id'] ?? '',
      comment: parsedJson['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createDate.toString(),
      'delivery_status': status,
      'origin': origin,
      'destination': destination,
      'order_nr': orderNr,
      'weight': weight,
      'dimensions': dimensions,
      'type': type,
      'customer_info': customerInfo,
      'rider_id': riderID,
      'comment': comment,
    };
  }
}
