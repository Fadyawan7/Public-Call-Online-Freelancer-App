import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/features/category/providers/category_provider.dart';
import 'package:flutter_restaurant/features/freelancer/providers/freelancer_provider.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class FilterButton extends StatelessWidget {
  final List<String> categories;
  final Function(List<String>) onFilterApplied;
  final List<String>? initiallySelected;

  const FilterButton({
    Key? key,
    required this.categories,
    required this.onFilterApplied,
    this.initiallySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (context) => FilterDialog(
          categories: categories,
          initiallySelected: initiallySelected,
          onFilterApplied: onFilterApplied,
        ),
      ),
      child: const Icon(Icons.filter_alt_outlined, size: 25),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final List<String> categories;
  final Function(List<String>) onFilterApplied;
  final List<String>? initiallySelected;

  const FilterDialog({
    Key? key,
    required this.categories,
    required this.onFilterApplied,
    this.initiallySelected,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late List<String> selectedCategories=[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filter Categories'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: Consumer<CategoryProvider>(
        builder: (context,categoryProvider,child){
          return SingleChildScrollView(
            child: Consumer<FreelancerProvider>(
              builder: (context,freelancerProvider,child){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: categoryProvider.categoryList!.map((category) {
                        final isSelected = freelancerProvider.selectedCategoryID == category.id!;
                        return FilterChip(
                          selectedColor: Theme.of(context).primaryColor,
                          label: Text(category.name!,style: rubikRegular.copyWith(
                            fontSize:
                            Dimensions.paddingSizeDefault,
                          ),),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                                freelancerProvider.setCategoryID(categoryID:category.id);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => freelancerProvider.resetCategoryID(),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              getTranslated('Clear All', context)!,
                              style: rubikSemiBold.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),

                        CustomButtonWidget(
                          onTap: (){
                            freelancerProvider.getFreelancerList(categoryId:freelancerProvider.selectedCategoryID );

                            Navigator.pop(context);

                          } ,
                          btnTxt: "Apply",
                          width: Dimensions.paddingSizeOverLarge*2,
                          height: Dimensions.paddingSizeLarge*2,
                        ),

                      ],
                    ),
                  ],
                );
              },
            ),
          );
        } ,),
    );
  }
}

// Usage Example
class MyHomePage extends StatelessWidget {
  final List<String> categories = [
    'Technology',
    'Design',
    'Marketing',
    'Finance',
    'Health'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Demo'),
        actions: [
          FilterButton(
            categories: categories,
            onFilterApplied: (selected) {
              print('Selected categories: $selected');
              // Update your state here
            },
            initiallySelected: ['Technology', 'Design'],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(),
    );
  }
}