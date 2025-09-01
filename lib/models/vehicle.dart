class Vehicle {
  final String id;
  final String name;
  final String brand;
  final String model;
  final VehicleCategory category;
  final String imageUrl;
  final List<String> features;
  final double pricePerDay;
  final double rating;
  final int reviewCount;
  final FuelType fuelType;
  final TransmissionType transmission;
  final int seats;
  final int doors;
  final bool isAvailable;
  final String? ownerId;
  final String location;
  final DateTime createdAt;

  const Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.category,
    required this.imageUrl,
    required this.features,
    required this.pricePerDay,
    required this.rating,
    required this.reviewCount,
    required this.fuelType,
    required this.transmission,
    required this.seats,
    required this.doors,
    this.isAvailable = true,
    this.ownerId,
    required this.location,
    required this.createdAt,
  });

  String get displayName => '$brand $model';
}

enum VehicleCategory {
  economy,
  compact,
  sedan,
  suv,
  luxury,
  utility,
}

extension VehicleCategoryExtension on VehicleCategory {
  String get displayName {
    switch (this) {
      case VehicleCategory.economy:
        return 'Économique';
      case VehicleCategory.compact:
        return 'Compacte';
      case VehicleCategory.sedan:
        return 'Berline';
      case VehicleCategory.suv:
        return 'SUV';
      case VehicleCategory.luxury:
        return 'Luxe';
      case VehicleCategory.utility:
        return 'Utilitaire';
    }
  }

  String get icon {
    switch (this) {
      case VehicleCategory.economy:
        return '🚗';
      case VehicleCategory.compact:
        return '🚙';
      case VehicleCategory.sedan:
        return '🚘';
      case VehicleCategory.suv:
        return '🚐';
      case VehicleCategory.luxury:
        return '🏎️';
      case VehicleCategory.utility:
        return '🚛';
    }
  }
}

enum FuelType {
  gasoline,
  diesel,
  electric,
  hybrid,
}

extension FuelTypeExtension on FuelType {
  String get displayName {
    switch (this) {
      case FuelType.gasoline:
        return 'Essence';
      case FuelType.diesel:
        return 'Diesel';
      case FuelType.electric:
        return 'Électrique';
      case FuelType.hybrid:
        return 'Hybride';
    }
  }
}

enum TransmissionType {
  manual,
  automatic,
}

extension TransmissionTypeExtension on TransmissionType {
  String get displayName {
    switch (this) {
      case TransmissionType.manual:
        return 'Manuelle';
      case TransmissionType.automatic:
        return 'Automatique';
    }
  }
}