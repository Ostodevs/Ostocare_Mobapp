import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchItem> _suggestions = [];
  List<SearchItem> _allItems = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _allItems = [
      SearchItem(title: "Settings", subtitle: "App settings and preferences", icon: Icons.settings, route: '/settings'),
      SearchItem(title: "Profile", subtitle: "View your profile", icon: Icons.person, route: '/profile'),
      SearchItem(title: "Messages", subtitle: "Your conversations", icon: Icons.message, route: '/messages'),
      SearchItem(title: "Saved Posts", subtitle: "Posts you've saved", icon: Icons.bookmark, route: '/saved'),
      SearchItem(title: "Contact", subtitle: "Contact our agents", icon: Icons.contact_phone_rounded, route: '/supplyselect'),
      SearchItem(title: "Explore", subtitle: "Discover new content", icon: Icons.explore, route: '/explore'),
    ];

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
      });
      return;
    }

    final List<SearchItem> filteredItems = _allItems.where((item) {
      return item.title.toLowerCase().contains(query) || item.subtitle.toLowerCase().contains(query);
    }).toList();

    filteredItems.sort((a, b) {
      final aTitle = a.title.toLowerCase();
      final bTitle = b.title.toLowerCase();
      if (aTitle == query && bTitle != query) return -1;
      if (bTitle == query && aTitle != query) return 1;
      if (aTitle.startsWith(query) && !bTitle.startsWith(query)) return -1;
      if (bTitle.startsWith(query) && !aTitle.startsWith(query)) return 1;
      return aTitle.compareTo(bTitle);
    });

    setState(() {
      _suggestions = filteredItems;
      _isSearching = true;
    });
  }

  void _navigateToItem(SearchItem item) {
    _searchController.clear();
    Navigator.pushNamed(context, item.route);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: Color(0xFF9CE7F8),
          elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF9CE7F8), Color(0xFF00A8CF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _isSearching
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _searchController.clear(),
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Expanded(
              child: _isSearching ? _buildSuggestionsList() : _buildTrendingGridStyled(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    if (_suggestions.isEmpty) {
      return const Center(child: Text('No results found'));
    }
    return ListView.builder(
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final item = _suggestions[index];
        return ListTile(
          leading: Icon(item.icon),
          title: Text(item.title),
          subtitle: Text(item.subtitle),
          onTap: () => _navigateToItem(item),
        );
      },
    );
  }

  Widget _buildTrendingGridStyled() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('trendingPosts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No trending posts available'));
        }

        final docs = snapshot.data!.docs;
        docs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;

          // Get 'position' or use an empty map if missing
          final aPosition = aData['position'] is Map<String, dynamic> ? aData['position'] as Map<String, dynamic> : {};
          final bPosition = bData['position'] is Map<String, dynamic> ? bData['position'] as Map<String, dynamic> : {};

          // Extract x and y values with fallback
          final aX = aPosition['x'] ?? 0;
          final aY = aPosition['y'] ?? 0;
          final bX = bPosition['x'] ?? 0;
          final bY = bPosition['y'] ?? 0;

          // Sort first by y, then by x
          if (aY == bY) {
            return aX.compareTo(bX);
          }
          return aY.compareTo(bY);
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: StaggeredGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return StaggeredGridTile.count(
                crossAxisCellCount: data['cross'] ?? 1,
                mainAxisCellCount: data['main'] ?? 1,
                child: StomaCard(
                  title: data['title'] ?? '',
                  image: data['imageUrl'] ?? '',
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class StomaCard extends StatelessWidget {
  final String title;
  final String image;

  const StomaCard({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: image.startsWith('http')
              ? NetworkImage(image) as ImageProvider
              : AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SearchItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  SearchItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}
