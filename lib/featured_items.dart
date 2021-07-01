import 'package:flutter/material.dart';

import 'breakpoint_layout.dart';

class FeaturedItems extends StatelessWidget {
  const FeaturedItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BreakpointLayoutBuilder(
      breakpoints: <BreakpointLayout>[
        BreakpointLayout(560, (BuildContext context, BoxConstraints constraints) => ItemList(items: allItems)),
        BreakpointLayout(double.infinity, (BuildContext context, BoxConstraints constraints) => ItemGrid(items: allItems)),
      ],
    );
  }
}

class ItemList extends StatelessWidget {
  const ItemList({Key? key,
    required this.items,
  }) : super(key: key);

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ItemListTile(item: items[index]),
    );
  }
}

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Placeholder(),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name, style: Theme.of(context).textTheme.bodyText1),
              SizedBox(height: 8),
              Text(item.tags, style: Theme.of(context).textTheme.caption),
              Text(item.weight, style: Theme.of(context).textTheme.caption),
            ],
          ),
          Spacer(),
          Text(item.price, style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }
}

class ItemGrid extends StatelessWidget {
  const ItemGrid({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (BuildContext context, int index) => ItemCard(item: items[index]),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // maxCrossAxisExtent: cardSize.width,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        // mainAxisExtent: cardSize.height,
        childAspectRatio: cardSize.width / cardSize.height,
      ),
    );
  }
}

const Size cardSize = Size(250, 445);

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardSize.width,
      // height: cardSize.height,
      child: Card(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              // width: cardSize.width,
              // height: cardSize.width,
              child: Placeholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(item.name, style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis)),
                      Text(item.price, style: Theme.of(context).textTheme.bodyText1),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(item.tags, style: Theme.of(context).textTheme.caption, overflow: TextOverflow.ellipsis),
                  Text(item.weight, style: Theme.of(context).textTheme.caption),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Add to cart'),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

class Item {
  const Item({
    required this.name,
    required this.imageAssetName,
    required this.price,
    required this.tags,
    required this.weight,
  });

  final String name;
  final String imageAssetName;
  final String price;
  final String tags;
  final String weight;
}

const List<Item> allItems = [
  Item(name: 'Honeydew melon', imageAssetName: 'honeydew', price: '\$4.99', tags: 'Honeydew Fresh Organic', weight: '4.25 lb'),
  Item(name: 'Sourdough loaf', imageAssetName: 'sourdough', price: '\$8.99', tags: 'Artisanal Bread Sourdough', weight: '15 lb'),
  Item(name: 'Red onion', imageAssetName: 'onion', price: '\$3.49', tags: 'Produce Onion Organic', weight: '1 lb'),
  Item(name: 'Honeydew melon', imageAssetName: 'honeydew', price: '\$4.99', tags: 'Honeydew Fresh Organic', weight: '4.25 lb'),
  Item(name: 'Sourdough loaf', imageAssetName: 'sourdough', price: '\$8.99', tags: 'Artisanal Bread Sourdough', weight: '15 lb'),
  Item(name: 'Red onion', imageAssetName: 'onion', price: '\$3.49', tags: 'Produce Onion Organic', weight: '1 lb'),
  Item(name: 'Honeydew melon', imageAssetName: 'honeydew', price: '\$4.99', tags: 'Honeydew Fresh Organic', weight: '4.25 lb'),
  Item(name: 'Sourdough loaf', imageAssetName: 'sourdough', price: '\$8.99', tags: 'Artisanal Bread Sourdough', weight: '15 lb'),
  Item(name: 'Red onion', imageAssetName: 'onion', price: '\$3.49', tags: 'Produce Onion Organic', weight: '1 lb'),
];

