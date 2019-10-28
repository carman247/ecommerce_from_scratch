import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';

import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String image;
  final String title;

  UserProductItem({
    this.id,
    this.image,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            new DeleteUserProductButton(id: id),
          ],
        ),
      ),
    );
  }
}

class DeleteUserProductButton extends StatefulWidget {
  const DeleteUserProductButton({
    Key key,
    @required this.id,
  }) : super(key: key);

  final String id;

  @override
  _DeleteUserProductButtonState createState() =>
      _DeleteUserProductButtonState();
}

class _DeleteUserProductButtonState extends State<DeleteUserProductButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? CircularProgressIndicator()
        : IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to remove from your products?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await Provider.of<Products>(context,
                                      listen: false)
                                  .deleteProduct(widget.id);

                              Navigator.of(context).pop();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                    ),
                  ],
                ),
              );
            },
          );
  }
}
