import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
final TextEditingController _searchController = TextEditingController();
 var _searchQuery = '';
  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2, 
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
       bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.local_grocery_store), text: 'All Groceries'),
              Tab(icon: Icon(Icons.search), text: 'Search'),
            ],
          ),
        ),
      body: TabBarView(
        children: [
          _buildAllGroceriesTab(),
          _buildSearchTab(),
        ],

      ),
      ),
    );
       
  }
  Widget _buildAllGroceriesTab() {
    return ListView.builder(
      itemCount: dummyGroceryItems.length,
      itemBuilder: (context, index) =>
          GroceryTile(grocery: dummyGroceryItems[index]),
    );
  }

  Widget _buildSearchTab(){
     final filteredGroceries = dummyGroceryItems.where((grocery) {
      return grocery.name.toLowerCase().startsWith(_searchQuery.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(padding: const EdgeInsets.all(18),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search the groceries by name",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
        ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredGroceries.length,
            itemBuilder: (context, index) => GroceryTile(grocery: filteredGroceries[index]),
        ),
        ),
      ],
    );
    
    
  }
}

 

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
