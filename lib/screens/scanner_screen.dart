import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../models/adventure.dart';
import '../widgets/scanner_frame.dart';
import '../widgets/confetti_overlay.dart';
import '../providers/eco_state.dart';

class ScannerScreen extends StatefulWidget {
  final VoidCallback onScanComplete;

  const ScannerScreen({
    super.key,
    required this.onScanComplete,
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late final ConfettiController _confettiController;
  bool _isScanning = true;
  int _scanStep = 0; // 0: Product, 1: Bin QR, 2: Thrown item
  bool _showSuccessModal = false;
  int _earnedPoints = 0;
  String _detectedObject = '';
  String _detectedIcon = '';

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String get _statusMessage {
    if (!_isScanning) {
      if (_scanStep == 0) return 'Analizando producto con IA...';
      if (_scanStep == 1) return 'Validando QR de la papelera...';
      if (_scanStep == 2) return 'Verificando reciclaje (Fake or Not)...';
    }
    switch (_scanStep) {
      case 0: return 'Paso 1: Apunta al producto a reciclar';
      case 1: return 'Paso 2: Apunta al código QR de la papelera';
      case 2: return 'Paso 3: Foto del producto en la papelera';
      default: return '';
    }
  }

  void _triggerScan() {
    if (!_isScanning) return;

    setState(() {
      _isScanning = false;
    });

    if (_scanStep == 0) {
      // Step 1: Detect product
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (!mounted) return;
        
        _detectedObject = 'Botella de Plástico Aqua Pura';
        _earnedPoints = 30;
        _detectedIcon = '🥤';

        setState(() {
          _isScanning = true;
          _scanStep = 1;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Identificado: $_detectedObject (+$_earnedPoints pts)')));
      });
    } else if (_scanStep == 1) {
      // Step 2: Detect QR
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (!mounted) return;
        setState(() {
          _isScanning = true;
          _scanStep = 2;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código QR validado correctamente')));
      });
    } else if (_scanStep == 2) {
      // Step 3: Finalize and verify fake or not
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (!mounted) return;
        
        final ecoState = Provider.of<EcoState>(context, listen: false);
        ecoState.incrementMissionProgress('dm1', 1);
        
        final activeAdventure = ecoState.getActiveAdventure();
        final currentChapter = ecoState.getCurrentChapter(activeAdventure.id);
        if (currentChapter != null && currentChapter.type == ChapterType.scan) {
          ecoState.completeChapter(activeAdventure.id, currentChapter.id);
        }

        ecoState.addPoints(_earnedPoints, 'Reciclaje: $_detectedObject', _detectedIcon);

        setState(() {
          _showSuccessModal = true;
        });

        _confettiController.play();
      });
    }
  }

  void _closeSuccessModal() {
    setState(() {
      _showSuccessModal = false;
      _isScanning = true;
      _scanStep = 0;
    });
    widget.onScanComplete();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;

    return Scaffold(
      body: ConfettiOverlay(
        controller: _confettiController,
        child: Stack(
          children: [
            // Background camera feed with real images
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Center(
                child: Image.asset(
                  _scanStep == 0 
                    ? 'assets/images/step1.jpg' 
                    : (_scanStep == 1 ? 'assets/images/step2.png' : 'assets/images/step3.jpg'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            // Scanner Viewfinder Overlay
            ScannerFrame(
              statusText: _statusMessage,
              isScanning: _isScanning,
            ),

            // Top Header back navigation row
            Positioned(
              top: 48,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(AppTheme.rFull),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.flash_on_rounded, color: AppColors.adventureGold, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'CÁMARA IA ACTIVA (Paso ${_scanStep + 1}/3)',
                          style: AppTheme.tXs(Colors.white, FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Trigger buttons
            if (_isScanning && !_showSuccessModal)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton.large(
                    onPressed: _triggerScan,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.camera_rounded, size: 38),
                  ),
                ),
              ),

            // Premium Success dialog Modal Overlay
            if (_showSuccessModal)
              Container(
                color: Colors.black87,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(AppTheme.sp5),
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: AnimationController(
                      vsync: ScaffoldMessenger.of(context),
                      duration: AppTheme.durNorm,
                    )..forward(),
                    curve: Curves.elasticOut,
                  ),
                  child: Card(
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.rXl),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.sp5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppTheme.sp4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              '✅',
                              style: TextStyle(fontSize: 48),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '¡Reciclaje Válido!',
                            style: AppTheme.tLg(textC, FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'La IA ha comprobado que no es fake.\nHas reciclado correctamente:',
                            style: AppTheme.tXs(textM, FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _detectedObject,
                            style: AppTheme.tBase(AppColors.primary, FontWeight.w900),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Points Earned Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(AppTheme.rMd),
                              boxShadow: AppShadows.primary,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🪙', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(
                                  '+$_earnedPoints ECO-PUNTOS',
                                  style: AppTheme.tBase(Colors.white, FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Continue Button
                          ElevatedButton(
                            onPressed: _closeSuccessModal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.rMd),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Text(
                              'Continuar Aventura',
                              style: AppTheme.tBase(Colors.white, FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
