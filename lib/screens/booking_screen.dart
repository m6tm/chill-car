import 'package:flutter/material.dart';
import 'package:chilldrive/models/vehicle.dart';
import 'package:chilldrive/models/booking.dart';
import 'package:chilldrive/services/data_service.dart';

class BookingScreen extends StatefulWidget {
  final Vehicle vehicle;

  const BookingScreen({
    super.key,
    required this.vehicle,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String _pickupLocation = 'Yaoundé Centre';
  String _dropoffLocation = 'Yaoundé Centre';
  PaymentMethod _paymentMethod = PaymentMethod.airtelMoney;
  bool _withDriver = false;
  final TextEditingController _specialRequestsController = TextEditingController();
  bool _isLoading = false;

  double get _totalPrice {
    if (_startDate == null || _endDate == null) return 0;
    final days = _endDate!.difference(_startDate!).inDays + 1;
    double price = days * widget.vehicle.pricePerDay;
    if (_withDriver) price += days * 15000; // 15000 FCFA per day for driver
    return price;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate 
          ? (_startDate ?? DateTime.now().add(const Duration(days: 1)))
          : (_endDate ?? DateTime.now().add(const Duration(days: 2))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          if (_startDate == null || picked.isAfter(_startDate!)) {
            _endDate = picked;
          }
        }
      });
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner les dates')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final booking = Booking(
        id: 'b_${DateTime.now().millisecondsSinceEpoch}',
        userId: DataService.currentUser!.id,
        vehicleId: widget.vehicle.id,
        startDate: _startDate!,
        endDate: _endDate!,
        pickupLocation: _pickupLocation,
        dropoffLocation: _dropoffLocation,
        totalPrice: _totalPrice,
        status: BookingStatus.pending,
        paymentMethod: _paymentMethod,
        withDriver: _withDriver,
        specialRequests: _specialRequestsController.text.isEmpty ? null : _specialRequestsController.text,
        createdAt: DateTime.now(),
      );

      await DataService.createBooking(booking);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => BookingConfirmationScreen(booking: booking)),
          (route) => route.isFirst,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la réservation: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservation'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.vehicle.imageUrl,
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.directions_car),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.vehicle.displayName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.vehicle.pricePerDay.toStringAsFixed(0)} FCFA/jour',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Dates de location',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context, true),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _startDate == null 
                            ? 'Début'
                            : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _selectDate(context, false),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _endDate == null 
                            ? 'Fin'
                            : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Lieux de prise en charge et de retour',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _pickupLocation,
                decoration: const InputDecoration(
                  labelText: 'Lieu de prise en charge',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Yaoundé Centre', child: Text('Yaoundé Centre')),
                  DropdownMenuItem(value: 'Aéroport Yaoundé', child: Text('Aéroport Yaoundé')),
                  DropdownMenuItem(value: 'Douala', child: Text('Douala')),
                  DropdownMenuItem(value: 'Autre', child: Text('Autre lieu')),
                ],
                onChanged: (value) => setState(() => _pickupLocation = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _dropoffLocation,
                decoration: const InputDecoration(
                  labelText: 'Lieu de retour',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Yaoundé Centre', child: Text('Yaoundé Centre')),
                  DropdownMenuItem(value: 'Aéroport Yaoundé', child: Text('Aéroport Yaoundé')),
                  DropdownMenuItem(value: 'Douala', child: Text('Douala')),
                  DropdownMenuItem(value: 'Autre', child: Text('Autre lieu')),
                ],
                onChanged: (value) => setState(() => _dropoffLocation = value!),
              ),
              const SizedBox(height: 24),
              Text(
                'Options supplémentaires',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Avec chauffeur'),
                subtitle: const Text('+ 15 000 FCFA/jour'),
                value: _withDriver,
                onChanged: (value) => setState(() => _withDriver = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PaymentMethod>(
                value: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Mode de paiement',
                  border: OutlineInputBorder(),
                ),
                items: PaymentMethod.values.map((method) =>
                  DropdownMenuItem(
                    value: method,
                    child: Row(
                      children: [
                        Text(method.icon),
                        const SizedBox(width: 8),
                        Text(method.displayName),
                      ],
                    ),
                  ),
                ).toList(),
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialRequestsController,
                decoration: const InputDecoration(
                  labelText: 'Demandes spéciales (optionnel)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Récapitulatif',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_startDate != null && _endDate != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Durée:', style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                              '${_endDate!.difference(_startDate!).inDays + 1} jour(s)',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total:', style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            )),
                            Text(
                              '${_totalPrice.toStringAsFixed(0)} FCFA',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submitBooking,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Confirmer la réservation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;

  const BookingConfirmationScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 100,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Réservation confirmée !',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Votre réservation a été enregistrée avec succès. Vous recevrez bientôt un email de confirmation.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Numéro de réservation',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            booking.id.toUpperCase(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                ),
                child: const Text('Retour à l\'accueil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}