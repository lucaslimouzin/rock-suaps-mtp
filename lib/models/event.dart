class Event {
  final String id;
  final String name;
  final String description;
  final DateTime startDate; // Samedi
  final DateTime endDate;   // Dimanche
  final double price;
  final String imageUrl;
  final String location;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.imageUrl,
    required this.location,
  }) {
    // Vérification que l'événement commence un samedi
    if (startDate.weekday != DateTime.saturday) {
      throw Exception('L\'événement doit commencer un samedi');
    }
    // Vérification que l'événement se termine un dimanche
    if (endDate.weekday != DateTime.sunday) {
      throw Exception('L\'événement doit se terminer un dimanche');
    }
    // Vérification que l'événement dure exactement 2 jours
    if (endDate.difference(startDate).inDays != 1) {
      throw Exception('L\'événement doit durer exactement 2 jours');
    }
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    final startDate = DateTime.parse(json['start_date']);
    final endDate = DateTime.parse(json['end_date']);

    // Vérification des contraintes de dates
    if (startDate.weekday != DateTime.saturday) {
      throw Exception('L\'événement doit commencer un samedi');
    }
    if (endDate.weekday != DateTime.sunday) {
      throw Exception('L\'événement doit se terminer un dimanche');
    }
    if (endDate.difference(startDate).inDays != 1) {
      throw Exception('L\'événement doit durer exactement 2 jours');
    }

    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      startDate: startDate,
      endDate: endDate,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'price': price,
      'image_url': imageUrl,
      'location': location,
    };
  }
} 