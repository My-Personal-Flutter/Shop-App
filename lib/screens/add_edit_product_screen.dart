import 'dart:io';

import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routeName = "/add-edit-product";

  const AddEditProductScreen({Key? key}) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  List<String> _status = ["Online", "Offline"];
  String _selectedGroupValue = "Offline";
  late String _title;
  late XFile _image;
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
//   var urlPattern = r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
// var result = new RegExp(urlPattern, caseSensitive: false).firstMatch('https://www.google.com');

  Product _editedProduct = Product(
    id: null,
    description: null,
    imageUrl: null,
    price: 0.0,
    title: null,
  );

  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _title =
        (ModalRoute.of(context)!.settings.arguments) == null ? "Add" : "Edit";
    if (_title == "Edit") {
      String id = ModalRoute.of(context)!.settings.arguments as String;
      _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
          .getProductById(id);
      _initValues = {
        "title": _editedProduct.title!,
        "description": _editedProduct.description!,
        "price": _editedProduct.price.toString(),
        "imageUrl": _editedProduct.imageUrl!,
      };

      _image = XFile(_editedProduct.imageUrl!);
      if (_editedProduct.imageUrl!.startsWith("http")) {
        _selectedGroupValue = "Online";
      }
    } else {
      _image = XFile("");
    }
  }

  Future<void> getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) _image = image;
    });
  }

  Future<void> _saveForm() async {
    final isValidated = _formKey.currentState!.validate();
    if (!isValidated) {
      return;
    }
    if (_image.path != "") {
      _editedProduct = Product(
        id: _editedProduct.id,
        isFavourite: _editedProduct.isFavourite,
        description: _editedProduct.description,
        imageUrl: _image.path,
        price: _editedProduct.price,
        title: _editedProduct.title,
      );
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.id != null) {
        await Provider.of<ProductsProvider>(context, listen: false)
            .updateProduct(_editedProduct, _selectedGroupValue);
      } else {
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("An error occured"),
              content: const Text("Something went wrong"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text("Okay"),
                ),
              ],
            ),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Picture is missing!",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_title Product"),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              if (_selectedGroupValue == "Offline") {
                if (_image.path.startsWith("http")) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Please change image",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (_title == "Add") {
                  _saveForm();
                } else if (_title == "Edit") {
                  _saveForm();
                }
              } else {
                _saveForm();
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.photo_camera,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Picture",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                RadioGroup<String>.builder(
                                  direction: Axis.horizontal,
                                  groupValue: _selectedGroupValue,
                                  onChanged: (value) => setState(() {
                                    _selectedGroupValue = value!;
                                    //print(value);
                                  }),
                                  items: _status,
                                  itemBuilder: (item) => RadioButtonBuilder(
                                    item,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            InkWell(
                              onTap: _selectedGroupValue != "Online"
                                  ? getImage
                                  : () {},
                              splashColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                child: Container(
                                  width: 120,
                                  height: 100,
                                  color: Colors.black12,
                                  child: _title != "Edit"
                                      ? _image.path == ""
                                          ? const Icon(Icons.add)
                                          : _image.path.startsWith("http")
                                              ? Image.network(
                                                  _image.path,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  File(_image.path),
                                                  fit: BoxFit.cover,
                                                )
                                      : _image.path.startsWith("http")
                                          ? Image.network(
                                              _image.path,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(_image.path),
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        _selectedGroupValue == "Online"
                            ? Column(
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Image Url',
                                      border: OutlineInputBorder(),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    initialValue: _initValues['imageUrl'],
                                    onChanged: (value) {
                                      if (value.trim().isEmpty) {
                                        return;
                                      }
                                      if (!value.trim().startsWith("http") &&
                                          !value.trim().startsWith("https")) {
                                        return;
                                      }
                                      if (!value.trim().endsWith(".jpg") &&
                                          !value.trim().endsWith(".jpeg") &&
                                          !value.trim().endsWith("png")) {
                                        return;
                                      }
                                      setState(() {
                                        _image = XFile(value);
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.trim().isEmpty) {
                                        return "Url is missing";
                                      }
                                      if (!value.trim().startsWith("http") &&
                                          !value.trim().startsWith("https")) {
                                        return "Url is not valid";
                                      }
                                      if (!value.trim().endsWith(".jpg") &&
                                          !value.trim().endsWith(".jpeg") &&
                                          !value.trim().endsWith("png")) {
                                        return "Image is not supported ";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _editedProduct = Product(
                                        id: _editedProduct.id,
                                        isFavourite: _editedProduct.isFavourite,
                                        description: _editedProduct.description,
                                        imageUrl: value,
                                        price: _editedProduct.price,
                                        title: _editedProduct.title,
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                ],
                              )
                            : Container(),
                        TextFormField(
                          decoration: const InputDecoration(
                            // icon: Icon(
                            //   Icons.title,
                            //   color: Theme.of(context).primaryColor,
                            // ),
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _initValues["title"],
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            Focus.of(context).requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Title is missing";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              title: value,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            // icon: Icon(
                            //   Icons.attach_money,
                            //   color: Theme.of(context).primaryColor,
                            // ),
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _initValues["price"],
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            Focus.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Price is missing";
                            }
                            if (double.tryParse(value) == null) {
                              return "Pleas enter a valid number";
                            }
                            if (double.parse(value) <= 0) {
                              return "Please enter a number greater than 0";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value!),
                              title: _editedProduct.title,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            // icon: Icon(
                            //   Icons.description,
                            //   color: Theme.of(context).primaryColor,
                            // ),
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: _initValues["description"],
                          focusNode: _descriptionFocusNode,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Description is missing";
                            }
                            if (value.length < 10) {
                              return " Should be at least 10 characters long";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite,
                              description: value,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              title: _editedProduct.title,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
