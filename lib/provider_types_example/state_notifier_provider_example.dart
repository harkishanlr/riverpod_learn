import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Product Model
class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

// 2. Cart Item Model
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// 3. Cart State
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Product product) {
    final existingItemIndex =
        state.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex != -1) {
      increaseQuantity(existingItemIndex);
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeItem(int index) {
    state = state.where((item) => state.indexOf(item) != index).toList();
  }

  void increaseQuantity(int index) {
    if (index < 0 || index >= state.length) {
      return;
    }
    final newState = List<CartItem>.from(state);
    newState[index].quantity++;
    state = newState;
  }

  void decreaseQuantity(int index) {
    if (index < 0 || index >= state.length) {
      return;
    }
    final newState = List<CartItem>.from(state);
    if (newState[index].quantity > 1) {
      newState[index].quantity--;
      state = newState;
    } else {
      removeItem(index);
    }
  }
}

// 4. Providers
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final productsProvider = Provider<List<Product>>((ref) => [
      Product(id: 1, name: 'Laptop', price: 1200.0),
      Product(id: 2, name: 'Keyboard', price: 75.0),
      Product(id: 3, name: 'Mouse', price: 25.0),
      Product(id: 4, name: 'Monitor', price: 300.0),
    ]);

final totalCostProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(
      0.0,
      (previousValue, element) =>
          previousValue + (element.product.price * element.quantity));
});

// 5. UI Components
class ProductList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          title: Text(product.name),
          trailing: Text('\$${product.price.toStringAsFixed(2)}'),
          onTap: () => ref.read(cartProvider.notifier).addItem(product),
        );
      },
    );
  }
}

class CartItemList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    if (cartItems.isEmpty) {
      return const Center(child: Text("Your cart is empty"));
    }

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = cartItems[index];
        return ListTile(
          title: Text(cartItem.product.name),
          subtitle: Text('Quantity: ${cartItem.quantity}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () =>
                      ref.read(cartProvider.notifier).decreaseQuantity(index),
                  icon: const Icon(Icons.remove)),
              IconButton(
                onPressed: () =>
                    ref.read(cartProvider.notifier).increaseQuantity(index),
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: () =>
                    ref.read(cartProvider.notifier).removeItem(index),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CartSummary extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalCost = ref.watch(totalCostProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all()),
      child: Text('Total: \$${totalCost.toStringAsFixed(2)}'),
    );
  }
}

// 6. Main App
class StateNotifierProviderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Shopping Cart')),
        body: Column(
          children: [
            Expanded(flex: 1, child: ProductList()),
            const Divider(),
            Expanded(flex: 2, child: CartItemList()),
            CartSummary(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
