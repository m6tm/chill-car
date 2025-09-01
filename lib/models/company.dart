class Company {
  final String name;
  final String description;
  final String mission;
  final String vision;
  final String history;
  final String email;
  final String phone;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final List<String> services;
  final List<Partner> partners;
  final List<Promotion> promotions;

  const Company({
    required this.name,
    required this.description,
    required this.mission,
    required this.vision,
    required this.history,
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.services,
    required this.partners,
    required this.promotions,
  });
}

class Partner {
  final String id;
  final String name;
  final String type;
  final String description;
  final String? imageUrl;

  const Partner({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    this.imageUrl,
  });
}

class Promotion {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double discountPercentage;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  const Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.discountPercentage,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });

  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }
}