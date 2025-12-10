import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickrecruitementtask/product/product.dart';
// import 'package:quickrecruitementtask/product/product.dart'; // Assuming this import exists and is correct

// Define an aesthetic color scheme
const Color primaryColor = Color(0xFF009688); // Teal for primary action/header
const Color accentColor = Color(0xFFFFCC80); // Amber/Light Orange for accents (like ratings)
const Color backgroundColor = Color(0xFFF7F7F7); // Very light grey background

// Assuming Product class is defined elsewhere, but its structure is consistent

// 2. --- Product List Screen ---
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // State variables (No changes here)
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  final TextEditingController _searchController = TextEditingController();

  // API URL
  static const String _apiUrl = 'https://fakestoreapi.com/products';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- API Handling and Async Operations (No changes here) ---
  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final List<Product> fetchedProducts =
        jsonList.map((json) => Product.fromJson(json)).toList();

        Set<String> categorySet = fetchedProducts.map((p) => p.category).toSet();

        setState(() {
          _allProducts = fetchedProducts;
          _categories = ['All', ...categorySet.toList()];
          _applyFilters();
        });
      } else {
        _showErrorSnackBar('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Network error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- Search and Filter Logic (No changes here) ---
  void _onSearchChanged() {
    _applyFilters();
  }

  void _onCategoryChanged(String? newCategory) {
    if (newCategory != null) {
      setState(() {
        _selectedCategory = newCategory;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    final String searchText = _searchController.text.toLowerCase();
    Iterable<Product> results = _allProducts;

    if (_selectedCategory != 'All') {
      results = results.where((product) => product.category == _selectedCategory);
    }

    if (searchText.isNotEmpty) {
      results = results.where(
            (product) => product.title.toLowerCase().contains(searchText),
      );
    }

    setState(() {
      _filteredProducts = results.toList();
    });
  }

  // --- Utility for showing errors (No changes here) ---
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // --- UI Widget Builders ---

  // Skeleton Loader (Updated color/style slightly)
  Widget _buildSkeletonLoader() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4, // Increased elevation for skeleton
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // More rounded corners
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Lighter grey for better contrast
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title placeholder
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.grey[300],
                      margin: const EdgeInsets.only(bottom: 8.0),
                    ),
                    // Price placeholder
                    Container(
                      height: 10,
                      width: 50,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Actual Product Grid Item (Design improvements applied here)
  Widget _buildProductGrid() {
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No products found matching your criteria. Try adjusting the search or filter.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.7,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return Card(
          elevation: 8, // Increased elevation for a floating look
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // More rounded
          clipBehavior: Clip.antiAlias, // Ensures image adheres to border
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              Expanded(
                child: Container(
                  color: Colors.white, // White background for images
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
                  ),
                ),
              ),
              // Product Details
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Updated Description Style
                    Text(
                      product.description,
                      style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.blueGrey, fontSize: 12),
                      maxLines: 1, // Only show 1 line of description now
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price Style
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: primaryColor, // Use defined primary color
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        // Rating Style
                        Row(
                          children: [
                            const Icon(Icons.star, color: accentColor, size: 18), // Use accent color
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Apply light background
      appBar: AppBar(
        title: const Text('Product Catalog', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor, // Apply primary color
        elevation: 0, // Keep AppBar clean
      ),
      body: Column(
        children: [
          // --- Search Bar and Filter Dropdown ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search, color: primaryColor), // Primary icon color
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none, // Remove default border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5), // Highlight on focus
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Category Filter Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      icon: const Icon(Icons.filter_list, color: primaryColor),
                      onChanged: _onCategoryChanged,
                      items: _categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Product List/Grid with Pull-to-Refresh ---
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchProducts,
              color: primaryColor, // Color for the refresh indicator
              child: _isLoading
                  ? _buildSkeletonLoader()
                  : _buildProductGrid(),
            ),
          ),
        ],
      ),
    );
  }
}