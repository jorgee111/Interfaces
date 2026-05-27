import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/rank_item.dart';
import '../providers/eco_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;

    // Fetch Stats & Leaderboards
    final fullLb = state.getFullLeaderboard();
    final patrolLb = state.getPatrolLeaderboard();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mi Impacto Ecológico',
                      style: AppTheme.tXl(textC, FontWeight.w900),
                    ),
                    Text(
                      'Tu contribución al bienestar del parque Faunia.',
                      style: AppTheme.tSm(textM, FontWeight.w600),
                    ),
                    const SizedBox(height: 16),

                    // Stats Grid (Envases, Residuos, Kg Reciclados, Días Activos)
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: AppTheme.sp3,
                      mainAxisSpacing: AppTheme.sp3,
                      childAspectRatio: 1.4,
                      children: [
                        StatCard(
                          label: 'Envases Devueltos',
                          value: '12',
                          unit: '',
                          icon: Icons.inventory_2_rounded,
                          gradient: AppColors.statBlue,
                        ),
                        StatCard(
                          label: 'Residuos Separados',
                          value: '28',
                          unit: '',
                          icon: Icons.compost_rounded,
                          gradient: AppColors.statGreen,
                        ),
                        StatCard(
                          label: 'Kg Reciclados',
                          value: '4.3',
                          unit: 'kg',
                          icon: Icons.scale_rounded,
                          gradient: AppColors.statPurple,
                        ),
                        StatCard(
                          label: 'Días Activos',
                          value: '${state.state.streak}',
                          unit: 'días',
                          icon: Icons.calendar_today_rounded,
                          gradient: AppColors.statOrange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Heading
                    Text(
                      'Clasificaciones del Parque',
                      style: AppTheme.tMd(textC, FontWeight.w900),
                    ),
                    Text(
                      'Compite amistosamente con otros visitantes de Faunia.',
                      style: AppTheme.tSm(textM, FontWeight.w600),
                    ),
                    const SizedBox(height: 12),

                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(AppTheme.rMd),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          color: isDark ? DarkColors.bgCard : Colors.white,
                          borderRadius: BorderRadius.circular(AppTheme.rSm),
                          boxShadow: AppShadows.xs,
                        ),
                        labelStyle: AppTheme.tSm(textC, FontWeight.w800),
                        unselectedLabelStyle: AppTheme.tSm(textM, FontWeight.w600),
                        labelColor: textC,
                        unselectedLabelColor: textM,
                        tabs: const [
                          Tab(text: 'Individual'),
                          Tab(text: 'Patrullas'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // Individual Leaderboard
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4),
                itemCount: fullLb.length,
                itemBuilder: (context, index) {
                  final entry = fullLb[index];
                  return RankItem(
                    rank: entry['rank'],
                    name: entry['name'],
                    points: entry['pts'],
                    avatar: entry['avatar'],
                    isUser: entry['isUser'] ?? false,
                    badge: entry['badge'] ?? '',
                  );
                },
              ),

              // Patrol Leaderboard
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4),
                itemCount: patrolLb.length,
                itemBuilder: (context, index) {
                  final entry = patrolLb[index];
                  return RankItem(
                    rank: entry['rank'],
                    name: entry['name'],
                    points: entry['pts'],
                    avatar: '👥',
                    isUser: entry['isUser'] ?? false,
                    badge: entry['rank'] == 1 ? 'gold' : entry['rank'] == 2 ? 'silver' : entry['rank'] == 3 ? 'bronze' : '',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
