import 'package:flutter/material.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routeName = "/add-edit-product";

  const AddEditProductScreen({Key? key}) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  @override
  Widget build(BuildContext context) {
    final _priceFocusNode = FocusNode();
    final _descriptionFocusNode = FocusNode();
    String _title = ModalRoute.of(context)!.settings.arguments as String;

    @override
    void dispose() {
      super.dispose();
      _priceFocusNode.dispose();
      _descriptionFocusNode.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("$_title Product"),
        centerTitle: false,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    Focus.of(context).requestFocus(_priceFocusNode);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    Focus.of(context).requestFocus(_descriptionFocusNode);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  focusNode: _descriptionFocusNode,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
