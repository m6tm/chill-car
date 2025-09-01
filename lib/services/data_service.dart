import 'package:chilldrive/models/user.dart';
import 'package:chilldrive/models/vehicle.dart';
import 'package:chilldrive/models/booking.dart';
import 'package:chilldrive/models/company.dart';

class DataService {
  static const String _currentUserId = 'user_001';

  // Sample users
  static final List<User> _users = [
    User(
      id: 'user_001',
      firstName: 'Maxime',
      lastName: 'Onogo',
      email: 'maxime.onogo@gmail.com',
      phone: '+237 677 66 99 05',
      documentNumber: 'CNI123456789',
      address: 'Quartier Essos',
      city: 'Yaoundé',
      country: 'Cameroun',
      birthDate: DateTime(1990, 5, 15),
      role: UserRole.client,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: 'admin_001',
      firstName: 'Admin',
      lastName: 'CHILLCar',
      email: 'admin@chillcar.com',
      phone: '+237 699 00 00 00',
      role: UserRole.admin,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
  ];

  // Sample vehicles with real image URLs
  static final List<Vehicle> _vehicles = [
    Vehicle(
      id: 'v001',
      name: 'BMW Série 3',
      brand: 'BMW',
      model: 'Série 3',
      category: VehicleCategory.luxury,
      imageUrl: 'https://pixabay.com/get/g5e875f309e2636e68cf39e6dfc86a067ea3232f630c7b2fcf29d529d042e1ebdad3ab16e142acb2e8485f72355a6d895f669a2794996e0f6cfeb5501db3408ff_1280.jpg',
      features: ['GPS', 'Bluetooth', 'Climatisation', 'Cuir', 'Toit ouvrant'],
      pricePerDay: 65000,
      rating: 4.8,
      reviewCount: 24,
      fuelType: FuelType.gasoline,
      transmission: TransmissionType.automatic,
      seats: 5,
      doors: 4,
      location: 'Yaoundé Centre',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Vehicle(
      id: 'v002',
      name: 'Mercedes GLE',
      brand: 'Mercedes-Benz',
      model: 'GLE',
      category: VehicleCategory.suv,
      imageUrl: 'https://pixabay.com/get/gda12c73e6b561a171dd211b15b4ac1d17888d550b243e0e15c9ee01846902b7327a2f2bf5bb646a083badc9afef6b64fed271c4d19278f46f763d2b9361c9a06_1280.jpg',
      features: ['7 places', 'GPS', '4x4', 'Caméra de recul', 'Sièges chauffants'],
      pricePerDay: 85000,
      rating: 4.9,
      reviewCount: 18,
      fuelType: FuelType.diesel,
      transmission: TransmissionType.automatic,
      seats: 7,
      doors: 5,
      location: 'Douala',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Vehicle(
      id: 'v003',
      name: 'Toyota Corolla',
      brand: 'Toyota',
      model: 'Corolla',
      category: VehicleCategory.economy,
      imageUrl: 'https://pixabay.com/get/g1f33933151b33c3b453cd63fc07fb5a0ad8fc4ec755ddd126758e3bb05c1f3b81d8aa08b49250890398eec26113c02f156bc8d12515ba6d9609272d107198b5a_1280.jpg',
      features: ['Économique', 'Bluetooth', 'Climatisation', 'Direction assistée'],
      pricePerDay: 35000,
      rating: 4.5,
      reviewCount: 42,
      fuelType: FuelType.gasoline,
      transmission: TransmissionType.manual,
      seats: 5,
      doors: 4,
      location: 'Yaoundé',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Vehicle(
      id: 'v004',
      name: 'Audi A6',
      brand: 'Audi',
      model: 'A6',
      category: VehicleCategory.luxury,
      imageUrl: 'https://pixabay.com/get/g475717701aabe42e616e1a98394bc6c996dd5eee7d6b4c7a500333130a506736c059696e16c784d6aa38b5153b00094a3ef1011cc5bd3aa57af3edfd54a32f60_1280.png',
      features: ['Cuir', 'GPS Premium', 'Sound System', 'Toit panoramique'],
      pricePerDay: 75000,
      rating: 4.7,
      reviewCount: 31,
      fuelType: FuelType.hybrid,
      transmission: TransmissionType.automatic,
      seats: 5,
      doors: 4,
      location: 'Yaoundé',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Sample bookings
  static final List<Booking> _bookings = [
    Booking(
      id: 'b001',
      userId: _currentUserId,
      vehicleId: 'v001',
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().subtract(const Duration(days: 4)),
      pickupLocation: 'Yaoundé Centre',
      dropoffLocation: 'Yaoundé Centre',
      totalPrice: 195000,
      status: BookingStatus.completed,
      paymentMethod: PaymentMethod.airtelMoney,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      confirmedAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    Booking(
      id: 'b002',
      userId: _currentUserId,
      vehicleId: 'v003',
      startDate: DateTime.now().add(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 6)),
      pickupLocation: 'Aéroport Yaoundé',
      dropoffLocation: 'Hôtel Hilton',
      totalPrice: 105000,
      status: BookingStatus.confirmed,
      paymentMethod: PaymentMethod.creditCard,
      withDriver: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      confirmedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Company information
  static final Company _company = Company(
    name: 'CHILLCar',
    description: 'L\'application mobile innovante qui révolutionne la location de voitures, offrant une expérience fluide, sécurisée et ultra-moderne pour louer le véhicule de vos rêves en quelques clics.',
    mission: 'Faciliter la mobilité urbaine et interurbaine grâce à une solution digitale rapide, sécurisée et accessible à tous.',
    vision: 'Devenir une référence en matière de location de véhicules connectée, flexible et moderne, en s\'appuyant sur la digitalisation et la confiance client.',
    history: 'CHILLCar a été créée en 2024 avec l\'ambition de digitaliser et moderniser l\'expérience de location de voitures au Cameroun et en Afrique.',
    email: 'contact@chillcar.com',
    phone: '+237 699 00 00 00',
    whatsapp: '+237 677 66 99 05',
    facebook: 'chillcar.official',
    instagram: 'chillcar_official',
    services: [
      'Location courte durée (1 jour à 1 semaine)',
      'Location longue durée (1 mois et plus)',
      'Location avec chauffeur',
      'Assurance tous risques incluse',
      'Livraison et récupération',
      'Support client 24h/7j',
    ],
    partners: [
      Partner(
        id: 'p001',
        name: 'Agence Premium Cars',
        type: 'Agence partenaire',
        description: 'Spécialisée dans les véhicules haut de gamme',
      ),
      Partner(
        id: 'p002',
        name: 'Assurances Cameroun',
        type: 'Partenaire assurance',
        description: 'Couverture complète pour tous nos véhicules',
      ),
    ],
    promotions: [
      Promotion(
        id: 'pr001',
        title: 'Offre Week-end',
        description: 'Louez 2 jours, payez 1 seul ! Valable du vendredi au dimanche.',
        imageUrl: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
        discountPercentage: 50,
        startDate: DateTime.now().subtract(Duration(days: 30)),
        endDate: DateTime.now().add(Duration(days: 30)),
      ),
      Promotion(
        id: 'pr002',
        title: 'Première location',
        description: 'Bénéficiez de 20% de réduction sur votre première réservation.',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        discountPercentage: 20,
        startDate: DateTime.now().subtract(Duration(days: 15)),
        endDate: DateTime.now().add(Duration(days: 60)),
      ),
    ],
  );

  // Getters
  static User? get currentUser => _users.firstWhere((u) => u.id == _currentUserId);
  static List<Vehicle> get vehicles => List.unmodifiable(_vehicles);
  static List<Booking> get userBookings => _bookings.where((b) => b.userId == _currentUserId).toList();
  static Company get company => _company;

  // Methods
  static Vehicle? getVehicleById(String id) => _vehicles.cast<Vehicle?>().firstWhere((v) => v?.id == id, orElse: () => null);
  
  static List<Vehicle> getVehiclesByCategory(VehicleCategory category) => 
    _vehicles.where((v) => v.category == category).toList();

  static List<Vehicle> searchVehicles(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _vehicles.where((v) => 
      v.name.toLowerCase().contains(lowercaseQuery) ||
      v.brand.toLowerCase().contains(lowercaseQuery) ||
      v.model.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }

  static Future<String> createBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _bookings.add(booking);
    return booking.id;
  }
}