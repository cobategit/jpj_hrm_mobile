class SchedulePerday {
  final int? iduser;
  final String? checkin;
  final String? checkout;
  final String? tgl;
  final String? behavior;
  final String? token;

  const SchedulePerday({
    this.iduser,
    this.checkin,
    this.checkout,
    this.tgl,
    this.behavior,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'check_in': checkin,
      'check_out': checkout,
      'id_user': iduser,
      'tgl': tgl,
      'behavior': behavior,
      'token': token,
    };
  }

  @override
  String toString() {
    return 'tb_schedulePerDay{id_user:$iduser, check_in: $checkin, check_out: $checkout, tgl: $tgl,  behavior: $behavior, token: $token}';
  }
}
