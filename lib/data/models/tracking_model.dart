// api_response.dart

class Tracking {
  final bool success;
  final String message;
  final TrackingData data;

  Tracking({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      success: json['success'],
      message: json['message'],
      data: TrackingData.fromJson(json['data']),
    );
  }
}

class TrackingData {
  final List<HdTracking> hdTrackings;
  final List<ApiTracking> apiTrackings;

  TrackingData({
    required this.hdTrackings,
    required this.apiTrackings,
  });
  factory TrackingData.fromJson(Map<String, dynamic> json) {
    var hdList = json['hdTrackings'];
    var apiList = json['apiTrackings'];

    return TrackingData(
      hdTrackings: (hdList is List)
          ? hdList.map((x) => HdTracking.fromJson(x)).toList()
          : [],
      apiTrackings: (apiList is List)
          ? apiList.map((x) => ApiTracking.fromJson(x)).toList()
          : [],
    );
  }
}

class HdTracking {
  final int id;
  final int orderId;
  final String country;
  final String city;
  final String statusCode;
  final String type;
  final String description;
  final int createdBy;
  final int updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String trackingId;
  final String trackingCode;
  final String state;
  final String zipcode;

  HdTracking({
    required this.id,
    required this.orderId,
    required this.country,
    required this.city,
    required this.statusCode,
    required this.type,
    required this.description,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.trackingId,
    required this.trackingCode,
    required this.state,
    required this.zipcode,
  });

  factory HdTracking.fromJson(Map<String, dynamic> json) {
    print('run time order id');
    print(json['order_id'].runtimeType); // String

    return HdTracking(
      id: json['id'],
      orderId: int.parse(json['order_id'].toString()),
      country: json['country'],
      city: json['city'],
      statusCode: json['status_code'],
      type: json['type'],
      description: json['description'],
      createdBy: int.parse(json['created_by'].toString()),
      updatedBy: int.parse(json['updated_by'].toString()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      trackingId: json['tracking_id'],
      trackingCode: json['tracking_code'],
      state: json['state'],
      zipcode: json['zipcode'],
    );
  }

}

class ApiTracking {
  final String codigo;
  final String tipo;
  final DateTime dtHrCriado;
  final String descricao;
  final String detalhe;
  final Unidade unidade;

  ApiTracking({
    required this.codigo,
    required this.tipo,
    required this.dtHrCriado,
    required this.descricao,
    required this.detalhe,
    required this.unidade,
  });

  factory ApiTracking.fromJson(Map<String, dynamic> json) {
    return ApiTracking(
      codigo: json['codigo'],
      tipo: json['tipo'],
      dtHrCriado: DateTime.parse(json['dtHrCriado']),
      descricao: json['descricao'],
      detalhe: json['detalhe'],
      unidade: Unidade.fromJson(json['unidade']),
    );
  }
}

class Unidade {
  final String codSro;
  final String tipo;
  final Endereco endereco;

  Unidade({
    required this.codSro,
    required this.tipo,
    required this.endereco,
  });

  factory Unidade.fromJson(Map<String, dynamic> json) {
    return Unidade(
      codSro: json['codSro'],
      tipo: json['tipo'],
      endereco: Endereco.fromJson(json['endereco']),
    );
  }
}

class Endereco {
  final String cidade;
  final String uf;

  Endereco({
    required this.cidade,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cidade: json['cidade'],
      uf: json['uf'],
    );
  }
}
