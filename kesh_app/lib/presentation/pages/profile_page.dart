import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/nav_bar.dart';
import '../widgets/profile_details_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _controller = GetIt.I<ProfileController>();
  final _authController = GetIt.I<AuthController>();

  static const _backgroundColor = Color(0xFFF2F4F2);

  @override
  void initState() {
    super.initState();

    final userId = _authController.session?.userId;

    if (userId != null) {
      _controller.loadProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,

      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _controller.currentDateFormatted,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Seu perfil',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.notifications_none,
                                color: Colors.black87,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),

                          CircleAvatar(
                            backgroundColor: const Color(0xFFD6F399),
                            foregroundColor: Colors.green.shade900,
                            child: Text(
                              _controller.initials,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (_controller.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_controller.errorMessage != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Não foi possível carregar seu perfil.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                final userId = _authController.session?.userId;

                                if (userId != null) {
                                  _controller.loadProfile(userId);
                                }
                              },
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_controller.userDetails != null)
                    ProfileDetailsCard(controller: _controller)
                  else
                    const Center(child: Text('Nenhum perfil disponível.')),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await _authController.logout();
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Sair da conta',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
