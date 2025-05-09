import 'package:flutter/material.dart';
import 'package:qrcode/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class UrlCheckPage extends StatefulWidget {
  const UrlCheckPage({Key? key}) : super(key: key);

  @override
  _UrlCheckPageState createState() => _UrlCheckPageState();
}

class _UrlCheckPageState extends State<UrlCheckPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _apiService = ApiService(baseUrl: 'http://127.0.0.1:5000'); 
  
  bool _isLoading = false;
  UrlCheckResult? _result;
  String? _error;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _checkUrl() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _result = null;
        _error = null;
      });

      try {
        final result = await _apiService.checkUrl(_urlController.text);
        setState(() {
          _result = result;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Malicious URL Detector'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Enter URL to check',
                  hintText: 'https://example.com',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  // Simple URL validation
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return 'URL must start with http:// or https://';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _checkUrl,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Check URL'),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_result != null)
              Expanded(
                child: _buildResultCard(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final result = _result!;
    final isUrlMalicious = result.status == 'Malicious';
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isUrlMalicious ? Icons.dangerous : Icons.verified,
                  color: isUrlMalicious ? Colors.red : Colors.green,
                  size: 48,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'URL Status: ${result.status}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isUrlMalicious ? Colors.red : Colors.green,
                        ),
                      ),
                      Text(
                        result.url,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Domain Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  children: [
                    _buildTableRow('Registrar', result.domainInfo['registrar']),
                    _buildTableRow('Creation Date', result.domainInfo['creation_date']),
                    _buildTableRow('Organization', result.domainInfo['org']),
                    _buildTableRow('DNS Security', result.domainInfo['dnssec']),
                    _buildTableRow('Country', result.domainInfo['country']),
                    _buildTableRow('City', result.domainInfo['city']),
                    _buildTableRow('State', result.domainInfo['state']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, dynamic value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(value?.toString() ?? 'Unknown'),
        ),
      ],
    );
  }
}
