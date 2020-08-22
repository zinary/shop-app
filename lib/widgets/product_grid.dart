import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;
  ProductGrid(this.showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // title: products[i].title,
            // id: products[i].id,
            // imageUrl: products[i].imageUrl,
            ),
      ),
    );
  }
}
