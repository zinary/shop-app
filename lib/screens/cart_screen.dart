import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total Amount',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18),
                    ),
                    Spacer(),
                    Chip(
                      backgroundColor: Colors.orange,
                      label: Text(
                        cartData.totalAmount.toStringAsFixed(2),
                      ),
                    ),
                    OrderNowButton(cartData: cartData),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: cartData.itemCount,
                  itemBuilder: (ctx, i) => CartItem(
                        id: cartData.items.values.toList()[i].id,
                        productId: cartData.items.keys.toList()[i],
                        title: cartData.items.values.toList()[i].title,
                        price: cartData.items.values.toList()[i].price,
                        quantity: cartData.items.values.toList()[i].quantity,
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        : FlatButton(
            onPressed: (isLoading || widget.cartData.totalAmount <= 0)
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<Order>(context, listen: false).addItem(
                        widget.cartData.items.values.toList(),
                        widget.cartData.totalAmount);
                    setState(() {
                      isLoading = false;
                    });
                    widget.cartData.clear();
                  },
            child: Text(
              'Order Now',
              style: TextStyle(color: Colors.orange),
            ),
          );
  }
}
