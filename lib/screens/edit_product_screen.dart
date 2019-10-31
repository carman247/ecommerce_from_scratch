import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = ('/edit-product');
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _isInit = true;

  var _initValues = {'title': '', 'description': '', 'price': '', 'image': ''};

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    image: '',
  );

  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findProductById(id);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'image': ''
        };
        _imageUrlController.text = _editedProduct.image;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    try {
      final isValid = _form.currentState.validate();
      if (!isValid) {
        return;
      } else {
        _form.currentState.save();
        setState(() {
          _isLoading = true;
        });
        if (_editedProduct.id != null) {
          await Provider.of<Products>(context, listen: false)
              .updateProduct(_editedProduct.id, _editedProduct);
        } else {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        }
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                setState(() {
                  _isLoading = false;
                });
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: ('Title')),
                        initialValue: _initValues['title'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a title.';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: value,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              image: _editedProduct.image,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: ('Price')),
                        initialValue: _initValues['price'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: double.parse(value),
                              description: _editedProduct.description,
                              image: _editedProduct.image,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: ('Description')),
                        initialValue: _initValues['description'],
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 10) {
                            return 'Should be at least 10 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: value,
                              image: _editedProduct.image,
                              id: _editedProduct.id,
                              isFavourite: _editedProduct.isFavourite);
                        },
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image URL'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter an image URL.';
                            }
                            if (!value.startsWith('http') &&
                                !value.startsWith('https')) {
                              return 'Please enter a valid URL.';
                            }
                            if (!value.endsWith('.png') &&
                                !value.endsWith('.jpg') &&
                                !value.endsWith('.jpeg')) {
                              return 'Please provide a valid image (.jpg, .jpeg, .png)';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                image: value,
                                id: _editedProduct.id,
                                isFavourite: _editedProduct.isFavourite);
                          },
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          focusNode: _imageUrlFocusNode,
                          onFieldSubmitted: (_) => _saveForm,
                        ),
                      ),
                      _imageUrlController.text.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.photo,
                                color: Colors.black45,
                              ),
                              color: Colors.black12,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3,
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                              color: Colors.black12,
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                    ],
                  ),
                ),
              ),
            ),
      bottomSheet: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: MaterialButton(
          textColor: Theme.of(context).primaryTextTheme.title.color,
          color: Theme.of(context).primaryColor,
          child: Text('SAVE'),
          onPressed: _saveForm,
        ),
      ),
    );
  }
}
