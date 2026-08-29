import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../shared/services/firestore_service.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../products/domain/product_model.dart';

import '../widgets/category_menu.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _resetFilter() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'Semua';
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER WITH SEARCH & ACTIONS
              HomeHeader(
                searchController: _searchController,
                onSearchChanged: _onSearchChanged,
                onClearSearch: _clearSearch,
              ),

              const SizedBox(height: 18),

              // CATEGORY HORIZONTAL SELECTOR
              CategoryMenu(
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),

              const SizedBox(height: 16),

              // PROMO BANNER CAROUSEL (SHOWN WHEN NOT SEARCHING)
              if (_searchQuery.isEmpty && _selectedCategory == 'Semua') ...[
                const PromoBanner(),
                const SizedBox(height: 20),
              ],

              // TITLE & SORT BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _searchQuery.isNotEmpty
                          ? 'Hasil Pencarian'
                          : (_selectedCategory == 'Semua'
                              ? 'Katalog Tanaman'
                              : 'Kategori: $_selectedCategory'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    if (_searchQuery.isNotEmpty || _selectedCategory != 'Semua')
                      TextButton.icon(
                        onPressed: _resetFilter,
                        icon: const Icon(Icons.refresh, size: 14, color: Colors.green),
                        label: const Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // PRODUCT GRID SECTION
              StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                        child: Text(
                          'Terjadi kesalahan: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  final allDocs = snapshot.data?.docs ?? [];
                  final allProducts = allDocs
                      .map((doc) => Product.fromFirestore(doc))
                      .toList();

                  // APPLY FILTER & SEARCH
                  var filteredProducts = allProducts.where((product) {
                    final nameLower = product.name.toLowerCase();
                    final descLower = product.description.toLowerCase();
                    final queryLower = _searchQuery.toLowerCase();
                    final categoryLower = _selectedCategory.toLowerCase();

                    final matchesSearch = _searchQuery.isEmpty ||
                        nameLower.contains(queryLower) ||
                        descLower.contains(queryLower);

                    final matchesCategory = _selectedCategory == 'Semua' ||
                        nameLower.contains(categoryLower) ||
                        descLower.contains(categoryLower);

                    return matchesSearch && matchesCategory;
                  }).toList();

                  // EMPTY RESULTS
                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search_off,
                                color: Colors.green,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tanaman Tidak Ditemukan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'Tidak ada produk yang cocok dengan "$_searchQuery".'
                                  : 'Belum ada produk dalam kategori $_selectedCategory.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: _resetFilter,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Tampilkan Semua Tanaman',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // PRODUCT GRID
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: filteredProducts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(product: filteredProducts[index]);
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
