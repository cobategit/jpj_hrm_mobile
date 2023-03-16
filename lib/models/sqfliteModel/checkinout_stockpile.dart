class CheckInStockpile {
  final String token;
  final String tgl;
  final String idstockfile;
  final String checkin;
  final String longitude;
  final String latitude;
  final String device;
  final String picture;

  const CheckInStockpile({
    required this.token,
    required this.tgl,
    required this.idstockfile,
    required this.checkin,
    required this.longitude,
    required this.latitude,
    required this.device,
    required this.picture,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'tgl': tgl,
      'id_stock_file': idstockfile,
      'check_in': checkin,
      'longitude': longitude,
      'latitude': latitude,
      'device': device,
      'picture': picture
    };
  }

  @override
  String toString() {
    return 'tb_checkInStokpile{token: $token, tgl: $tgl, id_stock_file: $idstockfile, check_in: $checkin,longitude: $longitude, latitude: $latitude, device: $device, picture: $picture}';
  }
}

class CheckOutStockpile {
  final String token;
  final String tgl;
  final String idstockfile;
  final String checkout;
  final String longitude;
  final String latitude;

  const CheckOutStockpile({
    required this.token,
    required this.tgl,
    required this.idstockfile,
    required this.checkout,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'tgl': tgl,
      'id_stock_file': idstockfile,
      'check_out': checkout,
      'longitude_out': longitude,
      'latitude_out': latitude
    };
  }

  @override
  String toString() {
    return 'tb_checkOutStokpile{token: $token, tgl: $tgl, id_stock_file: $idstockfile, check_out: $checkout,longitude_out: $longitude, latitude_out: $latitude}';
  }
}
