import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ordProvider;

class OrderItem extends StatefulWidget {
  final ordProvider.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: 
            Icon(Icons.info,
                color: widget.order.isPending ? Colors.amber : Colors.green),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  child: Row(
                    children: <Widget>[
                      Text('${widget.order.id}',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ),
                widget.order.isPending
                    ? Text(
                        'Status: pending',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text(
                        'Status: COMPLETED',
                        style: TextStyle(color: Colors.grey),
                      ),
                Text('Total: £${widget.order.amount.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey),),
              ],
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy - hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: _expanded
                  ? Icon(Icons.expand_less,
                      color: Theme.of(context).primaryColor)
                  : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: widget.order.products
                      .map(
                        (product) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${product.title} x${product.quantity}',
                                textAlign: TextAlign.left, style: TextStyle(color: Colors.grey),
                              ),
                              Text(' £${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
