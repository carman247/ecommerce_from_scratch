import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:square_in_app_payments/in_app_payments.dart' as pay;
import 'package:square_in_app_payments/models.dart' as paymodel;

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

import '../widgets/cart_item.dart';

import '../screens/orders_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    // Provider.of<Cart> is the receiver of the cart provider.
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].title,
                cart.items.keys.toList()[index],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          cart.items.length == 0
              ? Container()
              : FlatButton(
                  child: Text('Clear Cart'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to clear your cart?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              cart.clearCart();
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    );
                  },
                  textColor: Theme.of(context).primaryColor,
                ),
          Container(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    elevation: cart.totalAmount <= 0 ? 0 : 5,
                    label: Text(
                      '£${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: cart.totalAmount <= 0
                        ? Colors.grey
                        : Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          OrderButton(cart: cart),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  void _pay() {
    pay.InAppPayments.setSquareApplicationId(
        'sandbox-sq0idb-QYkCo5BAYwYJgGNVD8AGQA');
    pay.InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
      onCardEntryCancel: _cardEntryCancel,
    );
  }

  void _cardEntryCancel() {
    // Cancel card entry
  }

  void _cardNonceRequestSuccess(paymodel.CardDetails result) {
    print(result.nonce);

    pay.InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete,
    );
  }

  void _cardEntryComplete() async {
    Provider.of<Orders>(context, listen: false).addOrder(
      widget.cart.items.values.toList(),
      widget.cart.totalAmount,
    );

    await widget.cart.clearCart();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Order has been placed.'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Go to Orders',
          onPressed: () {
            Scaffold.of(context).hideCurrentSnackBar();
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      textColor: Theme.of(context).primaryColor,
      disabledColor: Colors.transparent,
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async => _pay(),
    );
  }
}
