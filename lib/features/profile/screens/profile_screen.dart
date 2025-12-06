import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/features/authorization/cubit/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой профиль'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/garden'),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Вы не авторизованы',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Text(
                    'Ваш профиль',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Здесь отображается информация, указанная при регистрации. Эти данные используются для персонализации ухода за вашими растениями. В частности, на основе вашего региона автоматически подбираются рекомендации по выбору и уходу за растениями, адаптированные к местному климату и сезону.',
                  style: TextStyle(
                    fontSize: 15, // немного крупнее
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // === Основная информация ===
                _buildSectionHeader('Основная информация'),
                _buildInfoRow('Логин', user.login),

                const SizedBox(height: 20),

                // === Контактные данные ===
                _buildSectionHeader('Контактные данные'),
                if (user.phone != null)
                  _buildInfoRow('Телефон', user.phone!),
                if (user.email != null)
                  _buildInfoRow('Электронная почта', user.email!),
                if (user.phone == null && user.email == null)
                  const Text(
                    'Контактные данные не указаны',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                const SizedBox(height: 20),

                // === Регион ===
                _buildSectionHeader('Местоположение'),
                if (user.region != null)
                  _buildInfoRow('Регион проживания', user.region!),
                if (user.region == null)
                  const Text(
                    'Регион не указан',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                const Spacer(),


                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                        context.go('/auth');
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Выйти из аккаунта',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}