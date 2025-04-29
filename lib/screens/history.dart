import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:intl/intl.dart';
import 'package:wave/config.dart'; 

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with TickerProviderStateMixin {
  late AnimationController _listAnimationController;
  
  // Sample history data - in a real app, you would fetch this from a database
  final List<ScanHistory> _historyItems = [
    ScanHistory(
      url: 'https://legitimatesite.com/login',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isMalicious: false,
    ),
    ScanHistory(
      url: 'https://suspicious-phishing.com/amazon-verify',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isMalicious: true,
    ),
    ScanHistory(
      url: 'https://shopping.example.com/product/123',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isMalicious: false,
    ),
    ScanHistory(
      url: 'https://malware-download.site/file.exe',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isMalicious: true,
    ),
    ScanHistory(
      url: 'https://online-banking.example.com',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isMalicious: false,
    ),
    ScanHistory(
      url: 'https://social-media.example.com/profile',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isMalicious: false,
    ),
    ScanHistory(
      url: 'https://fake-lottery.scam/you-won',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isMalicious: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Animated wave header
          _buildWaveHeader(),
          
          // History list
          Expanded(
            child: _buildHistoryList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveHeader() {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: Stack(
        children: [
       Transform(
  alignment: Alignment.center,
  transform: Matrix4.identity()..scale(1.0, -1.0), // Flip vertically
  child: WaveWidget(
    config: CustomConfig(
      gradients: [
        [const Color(0xFF5B7FFF), const Color(0xFF4A6FFF)],
        [const Color(0xFF4A6FFF), const Color(0xFF7B9FFF)],
        [const Color(0xFF7B9FFF), const Color(0xFF5B7FFF)],
        [const Color(0xFF4A6FFF), const Color(0xFF8AAFFF)],
      ],
      durations: [7000, 5000, 6000, 4000],
      heightPercentages: [0.20, 0.23, 0.25, 0.28],
      gradientBegin: Alignment.topLeft, // Adjusted for downward flow
      gradientEnd: Alignment.bottomRight, // Adjusted for downward flow
      blur: MaskFilter.blur(BlurStyle.solid, 5),
    ),
    backgroundColor: Colors.transparent,
    size: const Size(double.infinity, 180),
    waveAmplitude: 5,
  ),
),
          
          // Header content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  
                  // Title
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Scan History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_historyItems.length} results',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0.5, 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return AnimatedBuilder(
      animation: _listAnimationController,
      builder: (context, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: _historyItems.length,
          itemBuilder: (context, index) {
            // Calculate delay for staggered animation
            final itemAnimation = Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _listAnimationController,
                curve: Interval(
                  (index / _historyItems.length) * 0.6, // Stagger the animations
                  (index / _historyItems.length) * 0.6 + 0.4,
                  curve: Curves.easeOutQuart,
                ),
              ),
            );
            
            final ScanHistory item = _historyItems[index];
            
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(itemAnimation),
              child: FadeTransition(
                opacity: itemAnimation,
                child: _buildHistoryItem(item),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHistoryItem(ScanHistory item) {
    final dateFormat = DateFormat('MMM d, yyyy \'at\' h:mm a');
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Show more details or actions when tapped
            _showHistoryDetails(item);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // URL and status indicator
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.url,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF2D3142),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusIndicator(item.isMalicious),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Timestamp
                Text(
                  dateFormat.format(item.timestamp),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Status description
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: item.isMalicious 
                        ? const Color(0xFFFFEBEE) 
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.isMalicious ? 'Potentially Malicious' : 'Safe',
                    style: TextStyle(
                      color: item.isMalicious 
                          ? const Color(0xFFD32F2F) 
                          : const Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(bool isMalicious) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isMalicious ? const Color(0xFFD32F2F) : const Color(0xFF4CAF50),
      ),
      child: Center(
        child: Icon(
          isMalicious ? Icons.warning_rounded : Icons.check_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  void _showHistoryDetails(ScanHistory item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatusIndicator(item.isMalicious),
                  const SizedBox(width: 12),
                  Text(
                    item.isMalicious ? 'Malicious URL Detected' : 'Safe URL',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: item.isMalicious 
                          ? const Color(0xFFD32F2F) 
                          : const Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'URL',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                item.url,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Scan Date',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                DateFormat('MMMM d, yyyy \'at\' h:mm a').format(item.timestamp),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 24),
              
              if (item.isMalicious)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Risk Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This URL was flagged for potential ${_getRandomThreat()}. It may attempt to steal personal information or install malicious software.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Threats Detected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This URL was scanned and no security threats were found. Safe to visit.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6FFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  String _getRandomThreat() {
    final threats = [
      'phishing',
      'malware distribution',
      'identity theft',
      'financial fraud',
      'credential harvesting'
    ];
    return threats[DateTime.now().microsecond % threats.length];
  }
}

// Model class for history items
class ScanHistory {
  final String url;
  final DateTime timestamp;
  final bool isMalicious;

  ScanHistory({
    required this.url,
    required this.timestamp,
    required this.isMalicious,
  });
}