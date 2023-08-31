import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/category_model.dart';
import 'cubit/payment_cubit.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({
    super.key,
    required this.saveCategory,
  });

  final Function saveCategory;

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final _addCategoryForm = GlobalKey<FormState>();
  var selectedCategory = CategoryModel(id: "", name: "", user_id: "");
  var categoryList = <CategoryModel>[];
  var categoryName = "";

  void addCategory() {
    final isValid = _addCategoryForm.currentState!.validate();

    if (isValid) {
      _addCategoryForm.currentState!.save();

      // add new category to firestore
      BlocProvider.of<PaymentCubit>(context).addCategory(categoryName);

      getCategory();
    }
  }

  void getCategory() async {
    final categoryListFromDatabase =
        await BlocProvider.of<PaymentCubit>(context).getCategoryList();

    setState(() {
      categoryList = categoryListFromDatabase;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentStateEditSuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Added new category successfully"),
            ),
          );
        } else if (state is PaymentStateError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is PaymentStateEditingData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(context).pop(context),
                  icon: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () => _addCategoryDialogBuilder(context),
                      child: const Text("Add"),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                const Divider(
                  color: Colors.blueGrey,
                  height: 1,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0),
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          categoryList[index].name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        onTap: () {
                          setState(() {
                            selectedCategory = categoryList[index];
                          });
                        },
                        shape: const Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.blueGrey,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        selectedTileColor: Colors.grey.withAlpha(100),
                        selected: selectedCategory.id == categoryList[index].id,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => widget.saveCategory(selectedCategory),
                  style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                        textStyle: MaterialStatePropertyAll(
                          GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Center(
                      child: Text('Confirm Category'),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addCategoryDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Custom Category',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          content: Form(
            key: _addCategoryForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Name",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(label: Text("name")),
                  validator: (value) {
                    if (value == null || value.trim() == "") {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    categoryName = value!;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: addCategory,
              child: const Text('Add Category'),
            ),
          ],
        );
      },
    );
  }
}
