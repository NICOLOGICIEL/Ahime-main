import 'package:flutter/material.dart';
import 'package:ahime/pages/artisan/page_artisan.dart';
import 'package:ahime/pages/hotel/page_hotel.dart';
import 'package:ahime/pages/transport/page_transport.dart';
import 'package:ahime/config/utils/resizable.dart';
import 'package:ahime/config/my_config.dart';

const Color myColorOrange = Color(0xFFF08A24);

class PageMainscreen extends StatefulWidget {
  const PageMainscreen({super.key});

  @override
  State<PageMainscreen> createState() => _PageMainscreenState();
}

class _PageMainscreenState extends State<PageMainscreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var myWidth = SizeConfig.safeBlockHorizontal!;

    return Scaffold(
      backgroundColor: myColorWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildLogo(),
              const SizedBox(height: 24),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: _buildServiceCard(
                        title: 'HÔTELS',
                        subtitle: 'Réservez votre hôtel',
                        icon: Icons.bed_rounded,
                        color: myColorBlue2,
                        onTap: () => pushPage(context, PageHotel()),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: _buildServiceCard(
                        title: 'TRANSPORT',
                        subtitle: 'Trouvez votre trajet',
                        icon: Icons.directions_bus_filled_rounded,
                        color: myColorGreen,
                        onTap: () => pushPage(context, const PageTransport()),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: _buildServiceCard(
                        title: 'ARTISANS',
                        subtitle: 'Trouvez un professionnel',
                        icon: Icons.handyman_rounded,
                        color: myColorOrange,
                        onTap: () => pushPage(context, const PageArtisan()),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myWidth * 4),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        '$imageUri/header.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 47),
              const SizedBox(width: 14),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: myColorBlue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle:
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), label: 'Accueil'),
        BottomNavigationBarItem(
            icon: Icon(Icons.event_note_rounded), label: 'Réservations'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_rounded), label: 'Favoris'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: 'Profil'),
      ],
    );
  }
}
