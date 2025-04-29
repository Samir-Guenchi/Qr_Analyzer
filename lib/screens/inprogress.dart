import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AnalyzingPage extends StatefulWidget {
  final String? url;
  
  // Made url optional with default value to fix the error
  const AnalyzingPage({super.key, this.url = ''});

  @override
  _AnalyzingPageState createState() => _AnalyzingPageState();
}

class _AnalyzingPageState extends State<AnalyzingPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  bool _isAnalyzing = true;
  String _currentStep = 'Initializing...';
  double _progress = 0.0;
  final List<String> _steps = [
    'Scanning URL...',
    'Analyzing content...',
    'Checking security...',
    'Validating structure...',
    'Finalizing results...',
  ];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {
        _progress = _progressAnimation.value;
        _updateStep(_progress);
      });
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnalyzing = false;
        });
        
        // Navigate to results page or show results here
        _finishAnalysis();
      }
    });
    
    // Start the animation
    _animationController.forward();
    
    // Actually process the URL here if available
    if (widget.url != null && widget.url!.isNotEmpty) {
      _processUrl(widget.url!);
    }
  }
  
  void _updateStep(double progress) {
    int stepIndex = (progress * _steps.length).floor();
    if (stepIndex >= _steps.length) stepIndex = _steps.length - 1;
    _currentStep = _steps[stepIndex];
  }
  
  // Process the URL from QR code - implement your actual processing logic here
  Future<void> _processUrl(String url) async {
    debugPrint('Processing URL: $url');
    // You would implement your actual URL processing here
    // This could include API calls, validation, security checks, etc.
    
    // For now, we're just using the animation to simulate processing
  }
  
  void _finishAnalysis() {
    // Navigate to results page with the processed data
    // For example:
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(
        context, 
        '/results',
        arguments: {
          'url': widget.url,
          // Add any additional data you have processed
        },
      );
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyzing QR Content'),
        backgroundColor: const Color(0xFF4A6FFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4A6FFF), Color(0xFF7B9FFF)],
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // URL display with overflow protection
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Analyzing URL:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A6FFF),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.url ?? 'No URL provided',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Animation and progress
                      if (_isAnalyzing) ...[
                        // Custom progress animation
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              // Progress bar
                              LinearProgressIndicator(
                                value: _progress,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                minHeight: 6,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Current step text
                              Text(
                                _currentStep,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Progress percentage
                              Text(
                                '${(_progress * 100).toInt()}%',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Animated icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.search,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ] else ...[
                        // Show completed state
                        const Icon(
                          Icons.check_circle,
                          size: 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Analysis Complete!',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Redirecting to results...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Footer wave without buttons
                SizedBox(
                  width: double.infinity,
                  height: 120,
                  child: Stack(
                    children: [
                      // Wave shape
                      ClipRect(
                        child: WaveWidget(
                          config: CustomConfig(
                            gradients: [
                              [const Color(0xFF5B7FFF), const Color(0xFF4A6FFF)],
                              [const Color(0xFF4A6FFF), const Color(0xFF7B9FFF)],
                              [const Color(0xFF7B9FFF), const Color(0xFF5B7FFF)],
                              [const Color(0xFF4A6FFF), const Color(0xFF8AAFFF)],
                            ],
                            durations: [6000, 7000, 6500, 7200],
                            heightPercentages: [0.60, 0.62, 0.64, 0.66],
                            gradientBegin: Alignment.bottomLeft,
                            gradientEnd: Alignment.topRight,
                            blur: MaskFilter.blur(BlurStyle.solid, 8),
                          ),
                          backgroundColor: Colors.transparent,
                          size: Size(double.infinity, 120),
                          waveAmplitude: 30,
                          waveFrequency: 1,
                        ),
                      ),
                      
                      // "Made by ensia" attribution
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: const Text(
                            'Made by ensia',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black26,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}