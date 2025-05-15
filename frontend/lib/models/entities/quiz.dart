class Quiz {
  final int id;
  final String statement;
  final DateTime created;
  final int points;
  final int? userId; // Opcional

  Quiz({
    required this.id,
    required this.statement,
    required this.created,
    required this.points,
    this.userId,
  });

  // fromJson constructor
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      statement: json['statement'],
      created: DateTime.parse(json['created']),
      points: json['points'],
      userId: json['user_id'], // puede ser null
    );
  }

  // toMap method (útil para convertir a JSON o almacenar)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'statement': statement,
      'created': created.toIso8601String(),
      'points': points,
      if (userId != null) 'user_id': userId,
    };
  }

  @override
  String toString() {
    return 'Quiz(id: $id, statement: "$statement", created: $created, points: $points, userId: $userId)';
  }
}
