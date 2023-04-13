class CheckInEmp {
  final String token;
  final String tgl;
  final int iddept;
  final String checkin;
  final String longitude;
  final String latitude;
  final String type;
  final String device;
  final String picture;
  final String iswfh;

  const CheckInEmp({
    required this.token,
    required this.tgl,
    required this.iddept,
    required this.checkin,
    required this.longitude,
    required this.latitude,
    required this.type,
    required this.device,
    required this.picture,
    required this.iswfh,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'tgl': tgl,
      'id_dept': iddept,
      'check_in': checkin,
      'longitude': longitude,
      'latitude': latitude,
      'type': type,
      'device': device,
      'picture': picture,
      'iswfh': iswfh,
    };
  }

  @override
  String toString() {
    return 'tb_checkInEmp{token: $token, tgl: $tgl, id_dept: $iddept, check_in: $checkin,longitude: $longitude, latitude: $latitude,type: $type, device: $device, picture: $picture, iswfh: $iswfh}';
  }
}

class CheckOutEmp {
  final String token;
  final String tgl;
  final String checkout;
  final String longitude;
  final String latitude;

  const CheckOutEmp({
    required this.token,
    required this.tgl,
    required this.checkout,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'tgl': tgl,
      'check_out': checkout,
      'longitude_out': longitude,
      'latitude_out': latitude,
    };
  }

  @override
  String toString() {
    return 'tb_checkOutEmp{token: $token, tgl: $tgl, check_out: $checkout,longitude_out: $longitude, latitude_out: $latitude}';
  }
}
