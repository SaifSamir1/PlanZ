import 'package:flutter/material.dart';

// Enum to manage selected payment option
enum PaymentOption { creditCard, paypal, applePay }

// Enum to manage selected invitation template
enum InvitationTemplate { elegant, geometric, rustic, vibrant }

class PaymentAndInvitationsScreen extends StatefulWidget {
  const PaymentAndInvitationsScreen({super.key});

  @override
  State<PaymentAndInvitationsScreen> createState() =>
      _PaymentAndInvitationsScreenState();
}

class _PaymentAndInvitationsScreenState
    extends State<PaymentAndInvitationsScreen> {
  PaymentOption? _selectedPayment;
  InvitationTemplate? _selectedTemplate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: const Text("Payment & Invitations"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Payment Options Section ---
            const Text(
              'Payment Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPaymentOption(
              title: 'Credit Card',
              icon: Icons.credit_card,
              value: PaymentOption.creditCard,
            ),
            _buildPaymentOption(
              title: 'PayPal',
              icon: Icons.paypal,
              value: PaymentOption.paypal,
            ),
            _buildPaymentOption(
              title: 'Apple Pay',
              icon: Icons.apple,
              value: PaymentOption.applePay,
            ),
            const SizedBox(height: 20),

            // --- Event Details Section ---
            const Text(
              'Event Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Number of Attendees',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            // --- Invitation Templates Section ---
            const Text(
              'Invitation Templates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTemplateOption(
              title: 'Elegant Floral',
              description:
                  'A sophisticated design featuring subtle floral motifs, perfect for classic events.',
              image:
                  'assets/images/romantic-wedding-invitation-card-with-greenery-floral-free-png.webp', // <--- الاسم الكامل هنا
              value: InvitationTemplate.elegant,
            ),

            _buildTemplateOption(
              title: 'Modern Geometric',
              description:
                  'Clean lines and abstract shapes create a contemporary and stylish invitation.',
              image: 'assets/images/download.png', // Use your own image path
              value: InvitationTemplate.geometric,
            ),
            _buildTemplateOption(
              title: 'Rustic Charm',
              description:
                  'Inspired by nature, this template features earthy tones and organic elements.',
              image:
                  'assets/images/rustic_charm.png', // Use your own image path
              value: InvitationTemplate.rustic,
            ),
            _buildTemplateOption(
              title: 'Vibrant Celebration',
              description:
                  'Bold colors and playful elements make this template ideal for lively and joyous.',
              image:
                  'assets/images/vibrant_celebration.png', // Use your own image path
              value: InvitationTemplate.vibrant,
            ),
          ],
        ),
      ),
      // --- Bottom Buttons ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Preview Event in AR',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow[700],
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirm & Send Invitations',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for payment options
  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required PaymentOption value,
  }) {
    return RadioListTile<PaymentOption>(
      title: Text(title),
      secondary: Icon(icon, color: Colors.grey[700]),
      value: value,
      groupValue: _selectedPayment,
      onChanged: (PaymentOption? newValue) {
        setState(() {
          _selectedPayment = newValue;
        });
      },
      activeColor: Colors.deepPurple,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  // Helper widget for invitation templates
  Widget _buildTemplateOption({
    required String title,
    required String description,
    required String image,
    required InvitationTemplate value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _selectedTemplate == value
              ? Colors.deepPurple
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTemplate = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // Using a placeholder icon if the image fails to load
                child: Image.asset(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Radio<InvitationTemplate>(
                value: value,
                groupValue: _selectedTemplate,
                onChanged: (InvitationTemplate? newValue) {
                  setState(() {
                    _selectedTemplate = newValue;
                  });
                },
                activeColor: Colors.deepPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
