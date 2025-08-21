import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';

/// Example widget showing how to use Lunaria assets
class AssetExampleWidget extends StatelessWidget {
  const AssetExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Lunaria Assets Example', style: AppTextStyles.h6),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colors Section
            _SectionCard(
              title: 'Colors',
              child: Column(
                children: [
                  _ColorTile('Primary', AppColors.primary),
                  _ColorTile('Secondary', AppColors.secondary),
                  _ColorTile('Accent', AppColors.accent),
                  _ColorTile('Background', AppColors.background),
                  _ColorTile('Surface', AppColors.surface),
                  _ColorTile('Text Primary', AppColors.textPrimary),
                  _ColorTile('Success', AppColors.success),
                  _ColorTile('Error', AppColors.error),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Icons Section
            _SectionCard(
              title: 'SVG Icons',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _IconTile(AppAssets.iconCalendar, 'Calendar'),
                  _IconTile(AppAssets.iconBarbell, 'Barbell'),
                  _IconTile(AppAssets.iconPaw, 'Paw'),
                  _IconTile(AppAssets.iconPerson, 'Person'),
                  _IconTile(AppAssets.iconMessageAdd, 'Message Add'),
                  _IconTile(AppAssets.iconPlayFill, 'Play'),
                  _IconTile(AppAssets.iconCheck, 'Check'),
                  _IconTile(AppAssets.iconPlus, 'Plus'),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Images Section
            _SectionCard(
              title: 'Images',
              child: Column(
                children: [
                  // Pet Illustration
                  _ImageTile(
                    AppAssets.imagePetIllustration,
                    'Pet Illustration',
                    size: 100,
                  ),

                  const SizedBox(height: 16),

                  // Trainer Images Grid
                  Text('Trainer Images', style: AppTextStyles.h6),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: AppAssets.trainerImages.length,
                    itemBuilder: (context, index) {
                      return _ImageTile(
                        AppAssets.trainerImages[index],
                        'Trainer ${index + 1}',
                        size: 80,
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Typography Section
            _SectionCard(
              title: 'Typography',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Heading 1', style: AppTextStyles.h1),
                  Text('Heading 2', style: AppTextStyles.h2),
                  Text('Heading 3', style: AppTextStyles.h3),
                  Text('Heading 4', style: AppTextStyles.h4),
                  Text('Heading 5', style: AppTextStyles.h5),
                  Text('Heading 6', style: AppTextStyles.h6),
                  const SizedBox(height: 8),
                  Text('Body Large', style: AppTextStyles.bodyLarge),
                  Text('Body Medium', style: AppTextStyles.bodyMedium),
                  Text('Body Small', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 8),
                  Text('Button Large', style: AppTextStyles.buttonLarge),
                  Text('Button Medium', style: AppTextStyles.buttonMedium),
                  Text('Caption', style: AppTextStyles.caption),
                  Text('Label', style: AppTextStyles.label),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Gradient Section
            _SectionCard(
              title: 'Gradients',
              child: Column(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Primary Gradient',
                        style: AppTextStyles.buttonLarge,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppColors.backgroundGradient,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Background Gradient',
                        style: AppTextStyles.h6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.h5),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ColorTile extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorTile(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
          ),
          const SizedBox(width: 12),
          Text(name, style: AppTextStyles.bodyMedium),
          const Spacer(),
          Text(
            '#${color.value.toRadixString(16).toUpperCase()}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  final String iconPath;
  final String name;

  const _IconTile(this.iconPath, this.name);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: AppTextStyles.caption, textAlign: TextAlign.center),
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String imagePath;
  final String name;
  final double size;

  const _ImageTile(this.imagePath, this.name, {this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.surfaceVariant,
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.textTertiary,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: AppTextStyles.caption, textAlign: TextAlign.center),
      ],
    );
  }
}
