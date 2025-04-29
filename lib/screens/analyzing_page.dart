import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'dart:async';

class AnalyzingPage extends StatefulWidget {
  final String url;

  const AnalyzingPage({super.key, required this.url});

  @override
  State<AnalyzingPage> createState() => _AnalyzingPageState();
}

class _AnalyzingPageState extends State<AnalyzingPage> with SingleTickerProviderStateMixin {
  bool _isAnalyzing = true;
  bool _isSecure = false;
  String _analysisResult = '';
  String _domain = '';
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Extract domain from URL for display
    _domain = _extractDomain(widget.url);
    
    // Set up animation controller for progress indicator
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
    
    // Simulate analysis process
    _analyzeUrl();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  // Extract domain name from URL for display
  String _extractDomain(String url) {
    String domain = url;
    
    // Remove protocol
    if (domain.startsWith('https://')) {
      domain = domain.substring(8);
    } else if (domain.startsWith('http://')) {
      domain = domain.substring(7);
    }
    
    // Remove path and query parameters
    final pathIndex = domain.indexOf('/');
    if (pathIndex != -1) {
      domain = domain.substring(0, pathIndex);
    }
    
    return domain;
  }
  
  // Simulate URL analysis - in a real app, you would perform actual security checks
  Future<void> _analyzeUrl() async {
    // Simulate network delay and processing time
    await Future.delayed(const Duration(seconds: 3));
    
    // Simple security check (in a real app, you would do more complex analysis)
    final isSecure = widget.url.startsWith('https://');
    
    // Generate analysis result based on security
    String result;
    if (isSecure) {
      result = 'This website uses HTTPS encryption. Connection appears secure.';
    } else {
      result = 'Warning: This website does not use HTTPS encryption. Your connection may not be secure.';
    }
    
    // Update state with analysis results
    if (mounted) {
      setState(() {
        _isAnalyzing = false;
        _isSecure = isSecure;
        _analysisResult = result;
      });
    }
  }
  
  // Open URL in browser
  Future<void> _openUrl() async {
    final Uri url = Uri.parse(widget.url);
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open URL')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'URL Analysis',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4A6FFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isAnalyzing ? _buildAnalyzingContent() : _buildResultContent(),
          ),
          // Footer with wave effect (similar to FooterWidget)
          SizedBox(
            width: double.infinity,
            height: 100,
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
                    size: const Size(double.infinity, 100),
                    waveAmplitude: 20,
                    waveFrequency: 1,
                  ),
                ),
                // Footer content with buttons
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFooterButton(
                        context,
                        _isAnalyzing ? Icons.hourglass_top : Icons.home,
                        _isAnalyzing ? 'Wait' : 'Home',
                        _isAnalyzing ? null : () => Navigator.popUntil(context, ModalRoute.withName('/')),
                      ),
                      const SizedBox(width: 30),
                      _buildFooterButton(
                        context,
                        Icons.launch,
                        'Open URL',
                        _isAnalyzing ? null : _openUrl,
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
  
  // Content while analyzing URL
  Widget _buildAnalyzingContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // URL display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              widget.url,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 50),
          // Progress indicator
          SizedBox(
            width: 100,
            height: 100,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CircularProgressIndicator(
                  value: _progressAnimation.value,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF4A6FFF),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Analyzing URL',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A6FFF),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please wait while we check this URL for safety',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
  
  // Content after analysis is complete
  Widget _buildResultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Security status icon
          Icon(
            _isSecure ? Icons.security : Icons.security_update_warning,
            size: 80,
            color: _isSecure ? Colors.green : Colors.orange,
          ),
          const SizedBox(height: 24),
          // Domain name
          Text(
            _domain,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          // Full URL
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Text(
              widget.url,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          // Security assessment
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _isSecure ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isSecure ? Colors.green.shade200 : Colors.orange.shade200,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _isSecure ? 'Secure Connection' : 'Potential Risk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isSecure ? Colors.green.shade700 : Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _analysisResult,
                  style: TextStyle(
                    fontSize: 16,
                    color: _isSecure ? Colors.green.shade800 : Colors.orange.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Additional information about the URL
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What should you know?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A6FFF),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoItem(
                  Icons.info_outline,
                  'Always verify the domain name before entering personal information.',
                ),
                _buildInfoItem(
                  Icons.https,
                  'Look for HTTPS in the URL which indicates encrypted communication.',
                ),
                _buildInfoItem(
                  Icons.warning_amber,
                  'Be cautious of shortened URLs as they can hide the actual destination.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build info items
  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: const Color(0xFF4A6FFF)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
  
  // Reusable footer button (similar to FooterWidget)
  Widget _buildFooterButton(
    BuildContext context, 
    IconData icon, 
    String label, 
    VoidCallback? onPressed
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF4A6FFF),
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade600,
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        shadowColor: Colors.black26,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}