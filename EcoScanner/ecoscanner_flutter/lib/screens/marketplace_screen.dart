import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/reward_card.dart';
import '../models/reward.dart';
import '../providers/eco_state.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'todos';

  void _onRedeem(Reward reward) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('¿Canjear ${reward.title}?'),
          content: Text(
            'Se descontarán ${reward.cost} Eco-Puntos de tu balance actual. ¿Deseas continuar?',
            style: GoogleFonts.nunito(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final ecoState = Provider.of<EcoState>(context, listen: false);
                final success = ecoState.spendPoints(reward.cost);
                Navigator.pop(context);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '¡Canje Exitoso! Disfruta tu "${reward.title}". Tu cupón ha sido guardado. 🍿',
                        style: AppTheme.tSm(Colors.white, FontWeight.w700),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No tienes suficientes puntos.',
                        style: AppTheme.tSm(Colors.white, FontWeight.w700),
                      ),
                      backgroundColor: AppColors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;

    final int userPoints = state.state.points;

    // Filter Rewards
    final filteredRewards = kRewardsCatalog.where((r) {
      if (_selectedCategory == 'todos') return true;
      return r.category == _selectedCategory;
    }).toList();

    final List<Map<String, String>> categories = [
      {'id': 'todos', 'label': 'Todos'},
      {'id': 'comida', 'label': '🍿 Comida'},
      {'id': 'fastpass', 'label': '⚡ FastPass'},
      {'id': 'entradas', 'label': '🎟️ Entradas'},
      {'id': 'colec', 'label': '📍 Pins'},
    ];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Canje de Eco-Premios',
                style: AppTheme.tXl(textC, FontWeight.w900),
              ),
              Text(
                'Usa tus Eco-Puntos acumulados para conseguir premios y beneficios.',
                style: AppTheme.tSm(textM, FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Points balance display banner
              Container(
                padding: const EdgeInsets.all(AppTheme.sp4),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.rLg),
                  boxShadow: AppShadows.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TU BALANCE ACTUAL',
                          style: AppTheme.tXs(Colors.white.withOpacity(0.8), FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(
                              '$userPoints ECO-PUNTOS',
                              style: AppTheme.tMd(Colors.white, FontWeight.w900),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.sp2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_cart_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Category scroll selectors
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = _selectedCategory == cat['id'];

                    return Padding(
                      key: ValueKey(cat['id']),
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          cat['label']!,
                          style: AppTheme.tXs(
                            isSelected ? Colors.white : textC,
                            FontWeight.w800,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: cardBg,
                        checkmarkColor: Colors.white,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = cat['id']!;
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.rSm),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : textM.withOpacity(0.2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Rewards Catalog Grid view
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppTheme.sp3,
                    mainAxisSpacing: AppTheme.sp3,
                    childAspectRatio: 0.94,
                  ),
                  itemCount: filteredRewards.length,
                  itemBuilder: (context, index) {
                    final reward = filteredRewards[index];
                    return RewardCard(
                      reward: reward,
                      userPoints: userPoints,
                      onRedeemPressed: () => _onRedeem(reward),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
