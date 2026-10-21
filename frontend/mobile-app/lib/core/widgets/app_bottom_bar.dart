import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/screens/catalog/model_catalog_screen.dart';

class AppBottomBar extends StatelessWidget {

  final int currentIndex;

  const AppBottomBar({super.key, required this.currentIndex});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25)
        ) 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              if (currentIndex == 0) return;
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? AppColors.primary : AppColors.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              if (currentIndex == 1) return;
              Navigator.pushReplacementNamed(context, '/perfil');
            },
            icon: Icon(
              Icons.person,
              color: currentIndex == 1 ? AppColors.primary : AppColors.onSurface,
            ),
          ),
          Transform.translate(
            offset: Offset(0, -14),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: InkWell(
                child: Icon(Icons.bolt, color: AppColors.onPrimary, size: 30),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModelCatalogScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (currentIndex == 2) return;
              Navigator.pushReplacementNamed(context, '/history');
            },
            icon: Icon(
              Icons.history_outlined,
              color: currentIndex == 2 ? AppColors.primary : AppColors.onSurface,
            ),
          ),
          IconButton(
            onPressed: () {
              if (currentIndex == 3) return;
              Navigator.pushReplacementNamed(context, '/settings');
            },
            icon: Icon(
              Icons.settings,
              color: currentIndex == 3 ? AppColors.primary : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
  
