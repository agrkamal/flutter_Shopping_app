import 'package:flutter/material.dart';
import 'package:just_sell_it/const.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  final bool add;
  EditProductScreen({this.add = false});
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var initialValue = {
    'title': '',
    'imageUrl': '',
    'description': '',
    'price': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        initialValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
    }
    setState(() {});
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An Error Occured'),
            content: Text('Some Thing Went Wrong'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.add ? 'Add product' : 'Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              size: 34,
            ),
            onPressed: _saveForm,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(width: 12),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      cursorColor: kAccentColor,
                      // keyboardAppearance: Brightness.light,
                      enableSuggestions: true,
                      textCapitalization: TextCapitalization.words,
                      initialValue: initialValue['title'],
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: kColor),
                        labelText: 'Title',
                        fillColor: kAccentColor,
                        focusColor: kAccentColor,
                        hoverColor: kAccentColor,
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initialValue['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(color: kColor),
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a Valid Amount';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter a valid Amount';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value),
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                        );
                      },
                    ),
                    TextFormField(
                      enableSuggestions: true,
                      textCapitalization: TextCapitalization.sentences,
                      initialValue: initialValue['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: kColor),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                      focusNode: _descriptionNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Provide Description';
                        }
                        if (value.length < 10) {
                          return 'Min 10 Char required';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                        );
                      },
                    ),
                    if (_imageUrlController.text.isNotEmpty)
                      Container(
                        height: 250,
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                        labelStyle: TextStyle(color: kColor),
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) => _saveForm(),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Image URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          print(value);
                          return 'Enter a Valid URL';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')) {
                          return 'Enter a valid Image URL';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: value,
                          price: _editedProduct.price,
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
