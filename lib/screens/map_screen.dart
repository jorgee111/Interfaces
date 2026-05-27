import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TransformationController _transformationController = TransformationController();
  double _viewWidth = 0;
  double _viewHeight = 0;

  final List<Map<String, dynamic>> _pins = [
    {
      'id': 'p1',
      'title': 'Eco-Estación Entrada',
      'type': 'quest',
      'icon': '🌲',
      'x': 0.28,
      'y': 0.32,
      'desc': 'Contenedores de plástico y orgánico disponibles. Punto de partida de aventuras.',
      'points': '+30 Eco-Puntos por escaneo',
    },
    {
      'id': 'p2',
      'title': 'Fuente del Lago',
      'type': 'creature',
      'icon': '🐬',
      'x': 0.65,
      'y': 0.22,
      'desc': 'Eco-Estación acuática. El zorro de agua Leaf Fox suele descansar en los rosales de aquí.',
      'points': '+40 Eco-Puntos por escaneo',
    },
    {
      'id': 'p3',
      'title': 'Eco-Estación Central (Faunia)',
      'type': 'completed',
      'icon': '♻️',
      'x': 0.48,
      'y': 0.54,
      'desc': 'El nodo de reciclaje central. Ideal para reciclar vidrio e inorgánicos.',
      'points': '+50 Eco-Puntos por escaneo',
    },
    {
      'id': 'p4',
      'title': 'Bosque Perdido (Zona de Picnic)',
      'type': 'mystery',
      'icon': '🦌',
      'x': 0.35,
      'y': 0.72,
      'desc': 'Zona húmeda y sombría. Hay un misterio pendiente que requiere la llave dorada.',
      'points': 'Recompensa legendaria',
    },
  ];

  Map<String, dynamic>? _selectedPin;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_viewWidth > 0 && _viewHeight > 0) {
        _centerLocation();
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _centerLocation() {
    if (_viewWidth == 0 || _viewHeight == 0) return;
    final double targetX = 700.0;
    final double targetY = 500.0;
    final double scale = 1.5;
    
    final double tx = _viewWidth / 2 - targetX * scale;
    final double ty = _viewHeight / 2 - targetY * scale;

    _transformationController.value = Matrix4.identity()
      ..translate(tx, ty)
      ..scale(scale);
  }

  void _onPinTap(Map<String, dynamic> pin) {
    setState(() {
      _selectedPin = pin;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MapDetailSheet(pin: pin);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton(
        onPressed: _centerLocation,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.my_location_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.sp4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Mapa de Eco-Estaciones',
                style: AppTheme.tXl(textC, FontWeight.w900),
              ),
              Text(
                'Encuentra los contenedores de Faunia y localiza pistas.',
                style: AppTheme.tSm(textM, FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Interactive Simulated Map Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE2F4F0),
                    borderRadius: BorderRadius.circular(AppTheme.rXxl),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                      width: 2,
                    ),
                    boxShadow: AppShadows.sm,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.rXxl),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        _viewWidth = constraints.maxWidth;
                        _viewHeight = constraints.maxHeight;

                        return InteractiveViewer(
                          transformationController: _transformationController,
                          minScale: 0.5,
                          maxScale: 3.0,
                          constrained: false,
                          child: SizedBox(
                            width: 1400,
                            height: 1000,
                            child: Stack(
                              children: [
                                // Base Map Image
                                Positioned.fill(
                                  child: Image.asset(
                                    'assets/images/mapa_faunia.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                // Dynamic Pins Placement
                                ..._pins.map((pin) {
                                  Color pinColor = AppColors.primary;
                                  if (pin['type'] == 'quest') {
                                    pinColor = AppColors.adventureGold;
                                  } else if (pin['type'] == 'completed') {
                                    pinColor = AppColors.primary;
                                  } else if (pin['type'] == 'mystery') {
                                    pinColor = AppColors.purple;
                                  } else if (pin['type'] == 'creature') {
                                    pinColor = AppColors.blue;
                                  }

                                  final double posX = pin['x'] * 1400;
                                  final double posY = pin['y'] * 1000;

                                  return Positioned(
                                    left: posX - 20,
                                    top: posY - 40,
                                    child: PulseWidget(
                                      duration: Duration(seconds: 2 + (pin['title'] as String).length % 2),
                                      scaleStart: 0.94,
                                      scaleEnd: 1.06,
                                      child: GestureDetector(
                                        onTap: () => _onPinTap(pin),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: pinColor,
                                                shape: BoxShape.circle,
                                                boxShadow: AppShadows.sm,
                                                border: Border.all(color: Colors.white, width: 2),
                                              ),
                                              child: Text(
                                                pin['icon']!,
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            // Pin tail pointer
                                            Container(
                                              width: 4,
                                              height: 8,
                                              color: pinColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),

                                // User Location Dot (Simulated Real-time Location)
                                Positioned(
                                  left: 700 - 24, // center horizontally relative to width 1400
                                  top: 500 - 24,  // center vertically relative to height 1000
                                  child: PulseWidget(
                                    duration: const Duration(seconds: 2),
                                    scaleStart: 0.8,
                                    scaleEnd: 1.3,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 3),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 6,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapDetailSheet extends StatelessWidget {
  final Map<String, dynamic> pin;

  const _MapDetailSheet({required this.pin});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;

    Color pinColor = AppColors.primary;
    if (pin['type'] == 'quest') {
      pinColor = AppColors.adventureGold;
    } else if (pin['type'] == 'completed') {
      pinColor = AppColors.primary;
    } else if (pin['type'] == 'mystery') {
      pinColor = AppColors.purple;
    } else if (pin['type'] == 'creature') {
      pinColor = AppColors.blue;
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.rXxl),
          topRight: Radius.circular(AppTheme.rXxl),
        ),
        boxShadow: AppShadows.lg,
      ),
      padding: const EdgeInsets.all(AppTheme.sp5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: pinColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  pin['icon']!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pin['title']!,
                      style: AppTheme.tLg(textC, FontWeight.w900),
                    ),
                    Text(
                      pin['points']!,
                      style: AppTheme.tXs(pinColor, FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            pin['desc']!,
            style: AppTheme.tBase(textM, FontWeight.w600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: pinColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.rMd),
              ),
              padding: const EdgeInsets.all(14),
            ),
            child: Text(
              'Cerrar Detalles',
              style: AppTheme.tBase(Colors.white, FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
