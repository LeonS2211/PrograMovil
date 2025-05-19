class Isp {
  final int? id;
  final String ruc;
  final String name;
  final String address;


  Isp({
    this.id,
    required this.ruc,
    required this.name,
    required this.address,
  });


  factory Isp.fromJson(Map<String, dynamic> json) {
    return Isp(
      id: json['id'],
      ruc: json['ruc'],
      name: json['name'],
      address: json['address'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruc': ruc,
      'name': name,
      'address': address,
    };
  }
}

