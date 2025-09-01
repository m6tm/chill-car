import 'package:flutter/material.dart';
import 'package:chilldrive/models/vehicle.dart';
import 'package:chilldrive/services/data_service.dart';
import 'package:chilldrive/widgets/vehicle_card.dart';
import 'package:chilldrive/screens/vehicle_detail_screen.dart';

class VehicleListScreen extends StatefulWidget {
  final VehicleCategory? category;
  final String? searchQuery;

  const VehicleListScreen({
    super.key,
    this.category,
    this.searchQuery,
  });

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  List<Vehicle> _vehicles = [];
  List<Vehicle> _filteredVehicles = [];
  VehicleCategory? _selectedCategory;
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    _loadVehicles();
  }

  void _loadVehicles() {
    setState(() {
      if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
        _vehicles = DataService.searchVehicles(widget.searchQuery!);
      } else {
        _vehicles = DataService.vehicles;
      }
      _filterAndSortVehicles();
    });
  }

  void _filterAndSortVehicles() {
    List<Vehicle> filtered = _vehicles;

    // Filter by category
    if (_selectedCategory != null) {
      filtered = filtered.where((v) => v.category == _selectedCategory).toList();
    }

    // Sort vehicles
    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) => a.displayName.compareTo(b.displayName));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    setState(() {
      _filteredVehicles = filtered;
    });
  }

  String get _title {
    if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
      return 'Recherche: "${widget.searchQuery}"';
    } else if (widget.category != null) {
      return widget.category!.displayName;
    } else {
      return 'Tous les véhicules';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
              _filterAndSortVehicles();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text('Nom A-Z')),
              const PopupMenuItem(value: 'price_low', child: Text('Prix croissant')),
              const PopupMenuItem(value: 'price_high', child: Text('Prix décroissant')),
              const PopupMenuItem(value: 'rating', child: Text('Mieux notés')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.category == null && (widget.searchQuery?.isEmpty ?? true))
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FilterChip(
                    label: const Text('Tous'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                      _filterAndSortVehicles();
                    },
                  ),
                  ...VehicleCategory.values.map((category) => 
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Text(category.displayName),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? category : null;
                          });
                          _filterAndSortVehicles();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _filteredVehicles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun véhicule trouvé',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Essayez de modifier vos critères de recherche',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return VehicleCard(
                        vehicle: vehicle,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailScreen(vehicle: vehicle),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}