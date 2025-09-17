import 'package:flutter/material.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.zero, // Remove default padding
      ),
      child: Padding(
        // Add custom padding
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall,
          horizontal: Dimensions
              .paddingSizeSmall, // Adjust horizontal padding as needed
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Make button width based on content
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              // Conditionally add icon
              Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: Dimensions.fontSizeExtraLarge, // Adjust icon size
              ),
              const SizedBox(
                  width: Dimensions
                      .paddingSizeSmall), // Add spacing between icon and text
            ],
            Text(
              label,
              style: rubikSemiBold.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: Dimensions.fontSizeLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
