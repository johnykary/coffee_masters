import 'package:coffee_masters/datamanager.dart';
import 'package:flutter/material.dart';

import '../datamodel.dart';

class MenuPage extends StatelessWidget {
  final DataManager dataManager;
  const MenuPage({super.key, required this.dataManager});

  @override
  Widget build(BuildContext context) {
    // How to handle with future (promises)
    return FutureBuilder(
        future: dataManager.getMenu(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            // The future has finished, data is ready
            // ListView inside ListView
            var categories = snapshot.data!;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(categories[index].name),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: categories[index].products.length,
                      itemBuilder: ((context, productIndex) {
                        var product = categories[index].products[productIndex];
                        return ProductItem(
                            product: categories[index].products[productIndex],
                            onAdd: (addedProduct) =>
                                {dataManager.cartAdd(addedProduct)});
                      }),
                    )
                  ],
                );
              },
            );
          } else {
            if (snapshot.hasError) {
              // Data is not there because of an error
              return const Text("There was an error");
            } else {
              // Data is in progress( the future didnt finish)
              return const CircularProgressIndicator();
            }
          }
        }));
  }
}

class ProductItem extends StatelessWidget {
  // Imported properties from widget must be final
  final Product product;
  final Function onAdd;

  const ProductItem({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("\$${product.price}"),
                    ), //Double to string
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        onAdd(product);
                      },
                      child: const Text("Add")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
