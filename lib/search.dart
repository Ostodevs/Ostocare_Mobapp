import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), elevation: 0),
      body: Column(
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
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: _isSearching ? _buildSuggestionsList() : _buildTrendingGridStyled(),
          ),
        ],
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
    List<Map<String, dynamic>> trendingItems = [
      {'title': 'Checkups are Important', 'image': 'assets/search1.png', 'cross': 1, 'main': 2},
      {'title': 'Adapting to Life as an Ostomate', 'image': 'assets/search12.png', 'cross': 2, 'main': 1},
      {'title': 'A Healthy Life For Ostomates', 'image': 'assets/search11.png', 'cross': 1, 'main': 1},
      {'title': 'Relationships & Stomas', 'image': 'assets/search10.png', 'cross': 1, 'main': 2},
      {'title': 'Mental Health Awareness', 'image': 'assets/search9.png', 'cross': 1, 'main': 1},
      {'title': 'A Stoma Diet', 'image': 'assets/search8.png', 'cross': 1, 'main': 1},
      {'title': 'Here to Help', 'image': 'assets/search7.png', 'cross': 1, 'main': 1},
      {'title': 'Weight Lifting: Yes or No?', 'image': 'assets/search6.png', 'cross': 1, 'main': 2},
      {'title': 'Stoma Care & Hygiene', 'image': 'assets/search5.png', 'cross': 1, 'main': 2},
      {'title': 'Weight Gain or Loss?', 'image': 'assets/search4.png', 'cross': 1, 'main': 1},
      {'title': 'Choosing Stoma Products', 'image': 'assets/search3.png', 'cross': 2, 'main': 1},
      {'title': 'Paediatric Stomas', 'image': 'assets/search2.png', 'cross': 1, 'main': 1},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StaggeredGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: trendingItems.map((item) {
            return StaggeredGridTile.count(
              crossAxisCellCount: item['cross'],
              mainAxisCellCount: item['main'],
              child: StomaCard(title: item['title'], image: item['image']),
            );
          }).toList(),
        ),
      ),
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
          image: AssetImage(image),
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
