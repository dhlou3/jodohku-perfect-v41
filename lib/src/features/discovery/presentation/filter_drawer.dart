import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jodohku_malaysia/src/features/discovery/presentation/discovery_provider.dart';
import 'package:jodohku_malaysia/src/shared/constants/app_constants.dart';
import 'package:jodohku_malaysia/src/theme/app_theme.dart';

class FilterDrawer extends ConsumerStatefulWidget {
  const FilterDrawer({super.key});

  @override
  ConsumerState<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends ConsumerState<FilterDrawer> {
  double _distanceValue = 10;
  bool _waliVerifiedOnly = false;
  MaritalIntent _selectedIntent = MaritalIntent.immediate;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(discoveryFilterProvider);
    _distanceValue = currentFilters.maxDistance;
    _waliVerifiedOnly = currentFilters.waliVerifiedOnly;
    _selectedIntent = currentFilters.preferredIntent ?? MaritalIntent.immediate;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkEmerald,
      width: MediaQuery.of(context).size.width * 0.85,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _filterSectionTitle('Religiosity Scale'),
                    _buildReligiosityFilter(),
                    const Divider(height: 48, color: Colors.white10),
                    
                    _filterSectionTitle('Location (Malaysia)'),
                    _buildLocationFilter(),
                    const Divider(height: 48, color: Colors.white10),

                    _filterSectionTitle('Marital Intent'),
                    _buildMaritalIntentFilter(),
                    const Divider(height: 48, color: Colors.white10),

                    _buildToggleFilter(
                      'Wali Presence', 
                      'Only show profiles with a Guardian Verified badge',
                      _waliVerifiedOnly,
                      (val) => setState(() => _waliVerifiedOnly = val),
                    ),
                  ],
                ),
              ),
              _buildApplyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Advanced Filter',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Reset', style: TextStyle(color: AppColors.accentMint)),
        ),
      ],
    );
  }

  Widget _filterSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildReligiosityFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        '5x Daily', 'Occasional', 'Trying my best', 'Revert'
      ].map((tag) => _FilterChip(label: tag)).toList(),
    );
  }

  Widget _buildLocationFilter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Distance', style: TextStyle(color: Colors.white70)),
            Text('${_distanceValue.toInt()} km', style: const TextStyle(color: AppColors.accentMint)),
          ],
        ),
        Slider(
          value: _distanceValue,
          max: 100,
          divisions: 10,
          activeColor: AppColors.accentMint,
          onChanged: (val) => setState(() => _distanceValue = val),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          items: AppConstants.regions.map((region) => 
            DropdownMenuItem(value: region, child: Text(region))
          ).toList(),
          onChanged: (_) {},
          hint: const Text('Select City', style: TextStyle(color: Colors.white24)),
        ),
      ],
    );
  }

  Widget _buildMaritalIntentFilter() {
    return Column(
      children: MaritalIntent.values.map((intent) {
        String label = intent == MaritalIntent.immediate ? 'Get married within 1 year' :
                       intent == MaritalIntent.nearFuture ? 'Intro phase (1-2 years)' : 'Educational';
        return RadioListTile<MaritalIntent>(
          title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          value: intent,
          groupValue: _selectedIntent,
          activeColor: AppColors.accentMint,
          onChanged: (val) => setState(() => _selectedIntent = val!),
        );
      }).toList(),
    );
  }

  Widget _buildToggleFilter(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      value: value,
      activeColor: AppColors.accentMint,
      onChanged: onChanged,
    );
  }

  Widget _buildApplyButton() {
    return ElevatedButton(
      onPressed: () {
        ref.read(discoveryProvider.notifier).updateFilters(
          DiscoveryFilters(
            maxDistance: _distanceValue,
            waliVerifiedOnly: _waliVerifiedOnly,
            preferredIntent: _selectedIntent,
          ),
        );
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        backgroundColor: AppColors.accentMint,
      ),
      child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
    );
  }
}
