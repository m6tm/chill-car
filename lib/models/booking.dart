class Booking {
  final String id;
  final String userId;
  final String vehicleId;
  final DateTime startDate;
  final DateTime endDate;
  final String pickupLocation;
  final String dropoffLocation;
  final double totalPrice;
  final BookingStatus status;
  final PaymentMethod paymentMethod;
  final bool withDriver;
  final String? specialRequests;
  final DateTime createdAt;
  final DateTime? confirmedAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    this.withDriver = false,
    this.specialRequests,
    required this.createdAt,
    this.confirmedAt,
  });

  Duration get duration => endDate.difference(startDate);
  
  int get durationInDays => duration.inDays + (duration.inHours % 24 > 0 ? 1 : 0);
}

enum BookingStatus {
  pending,
  confirmed,
  active,
  completed,
  cancelled,
}

extension BookingStatusExtension on BookingStatus {
  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'En attente';
      case BookingStatus.confirmed:
        return 'Confirmée';
      case BookingStatus.active:
        return 'En cours';
      case BookingStatus.completed:
        return 'Terminée';
      case BookingStatus.cancelled:
        return 'Annulée';
    }
  }
}

enum PaymentMethod {
  airtelMoney,
  creditCard,
  cash,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.airtelMoney:
        return 'Airtel Money';
      case PaymentMethod.creditCard:
        return 'Carte bancaire';
      case PaymentMethod.cash:
        return 'Espèces';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.airtelMoney:
        return '📱';
      case PaymentMethod.creditCard:
        return '💳';
      case PaymentMethod.cash:
        return '💵';
    }
  }
}