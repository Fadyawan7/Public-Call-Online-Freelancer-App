
class PlaceBookingBody {
  int? _freelancerId;
  int? _addressId;

  String? _date;
  String? _time;
  String? _description;
  List<String>? _attachments;

  PlaceBookingBody(
      {
        int? freelancerId,
        int? addressId,

        String? date,
        String? time,
        String? description,
        List<String>? attachments,

      }) {
    _freelancerId = freelancerId;
    _addressId = addressId;
    _date = date;
    _time = time;
    _description = description;
    _attachments=attachments;

  }

  String? get description => _description;
  String? get date => _date;
  String? get time => _time;
  int? get freelancerId => _freelancerId;
  int? get addressId => _addressId;

  List<String>? get attachments => _attachments;

  PlaceBookingBody.fromJson(Map<String, dynamic> json) {
    _freelancerId = json['freelancer_id'];
    _addressId = json['address_id'];

    _time = json['time'];
    _date = json['date'];
    _description = json['description'];
    _attachments = json['attachments'].cast<String>();


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['freelancer_id'] = _freelancerId;
    data['address_id'] = _addressId;

    data['time'] = _time;
    data['date'] = _date;
    data['description'] = _description;
    data['attachments'] = _attachments;

    return data;
  }
}






