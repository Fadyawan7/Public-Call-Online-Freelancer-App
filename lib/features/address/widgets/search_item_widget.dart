import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/address/domain/models/prediction_model.dart';
import 'package:flutter_restaurant/features/freelancer/domain/models/freelancer_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';

class SearchItemWidget extends StatelessWidget {
  final FreelancerModel? suggestion;
  const SearchItemWidget({
    super.key, this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(
        children: [
          // Freelancer Image as Circle
          CircleAvatar(
            backgroundImage: suggestion?.image != null
                ? NetworkImage(suggestion!.image!)
                : const AssetImage('assets/image/placeholder_user.png') as ImageProvider,
            radius: 20, // Adjust the size of the circle
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          // Freelancer Name and Category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Freelancer Name
                Text(
                  suggestion?.name ?? getTranslated('no_freelancer_found', context)!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),

                // Freelancer Category
                if (suggestion?.freelancerCategory != null)
                  Text(
                    suggestion!.freelancerCategory!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}