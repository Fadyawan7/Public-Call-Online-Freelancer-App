class ReviewBody {
  int? _takerId;
  int? _bookingId;
  int? _rating;
  String? _comment;


  ReviewBody(
      {
        int? takerId,
        int? bookingId,
        int? rating,
        String? comment,
      }) {
    _takerId = takerId;
    _bookingId = bookingId;
    _comment = comment;
    _rating = rating;
  }

  int? get takerId => _takerId;
  int? get bookingId => _bookingId;
  String? get comment => _comment;
  int? get rating => _rating;

  ReviewBody.fromJson(Map<String, dynamic> json) {
    _takerId = json['taker_id'];
    _bookingId = json['booking_id'];
    _comment = json['comment'];
    _rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taker_id'] = _takerId;
    data['booking_id'] = _bookingId;
    data['comment'] = _comment;
    data['rating'] = _rating;
    return data;
  }
}
