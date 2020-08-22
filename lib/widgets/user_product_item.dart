import 'package:flutter/material.dart';
import '../screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    final scafffold = Scaffold.of(context);
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(shape: BoxShape.circle),
        width: 80,
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductsScreen.routeName, arguments: id);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteItem(id);
              } catch (error) {
                print(error);
                scafffold.removeCurrentSnackBar();
                scafffold.showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      'Delete failed.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
