import 'package:flutter/material.dart';


const Color primaryTextColor = Color(0xFFC79E45);
const Color secondaryTextColor = Color(0xFF333333);
const Color borderColor = Color(0xFFE0E0E0);
const Color cardBackgroundColor = Colors.white;

class FestivalScreen extends StatelessWidget {
  const FestivalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summer Music Festival',
          style: TextStyle(
            color: secondaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              _buildArPreviewButton(),
              const SizedBox(height: 20),
              _buildSummarySection(),
              const SizedBox(height: 16),
              _buildPackagesSection(),
              const SizedBox(height: 16),
              _buildAttendeesSection(),
              const SizedBox(height: 30),
              _buildActionButtons(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            height: 150,
            color: Colors.blueGrey,
            child: const Center(
              child: Text(
                'Image Placeholder',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Summer Music Festival',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Music Festival • \$15,000',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Chip(
                      label: const Text(
                        'Paid',
                        style: TextStyle(color: Colors.green),
                      ),
                      backgroundColor: Colors.green.withOpacity(0.1),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: const Text('Edit Event'),
                      backgroundColor: Colors.grey.shade700,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArPreviewButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.visibility_outlined, color: primaryTextColor),
      label: const Text(
        'AR Preview',
        style: TextStyle(color: primaryTextColor),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: primaryTextColor.withOpacity(0.05),
        side: const BorderSide(color: primaryTextColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }

  Widget _buildSummarySection() {
    return _buildExpansionCard(
      title: 'Summary',
      children: [
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Description',
            style: TextStyle(
              color: secondaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Get ready for the hottest music event of the summer! Featuring a diverse lineup of local and international artists, delicious food vendors, and interactive...',
            style: TextStyle(color: Colors.grey, height: 1.5),
          ),
        ),
        const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 4.0, right: 4.0),
            child: Text(
              '216/500 Characters',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoField('Date', 'July 12-14, 2024'),
        const SizedBox(height: 12),
        _buildInfoField('Time', '10:00 AM - 10:00 PM'),
        const SizedBox(height: 12),
        _buildInfoField('Location', 'City Park Amphitheater'),
      ],
    );
  }

  Widget _buildPackagesSection() {
    return _buildExpansionCard(
      title: 'Packages',
      children: [
        const SizedBox(height: 16),
        _buildPackageItem(
          company: 'SoundWave Productions',
          packageName: 'Standard Audio Package',
          items: ['2x JBL Line Arrays', '1x Digital Mixer', '2x Technicians'],
        ),
        const SizedBox(height: 20),
        _buildPackageItem(
          company: 'LightShow Innovations',
          packageName: 'Dynamic Lighting Setup',
          items: [
            '10x Moving Head Lights',
            'LED Uplighting',
            'Lighting Engineer',
          ],
        ),
      ],
    );
  }

  Widget _buildAttendeesSection() {
    return _buildExpansionCard(
      title: 'Attendees',
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Attendees (350)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: secondaryTextColor,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.people_outline, color: primaryTextColor),
              label: const Text(
                'Manage',
                style: TextStyle(color: primaryTextColor),
              ),
              style: TextButton.styleFrom(
                backgroundColor: primaryTextColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.person_add_alt_1_outlined,
            color: secondaryTextColor,
          ),
          label: const Text(
            'Invite Attendees',
            style: TextStyle(color: secondaryTextColor),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: borderColor),
              ),
              backgroundColor: Colors.white,
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: secondaryTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: secondaryTextColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: cardBackgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderColor),
      ),
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        iconColor: primaryTextColor,
        collapsedIconColor: primaryTextColor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        children: children,
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: secondaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(color: secondaryTextColor, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildPackageItem({
    required String company,
    required String packageName,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          company,
          style: const TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          packageName,
          style: const TextStyle(color: secondaryTextColor, fontSize: 14),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              '• $item',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
