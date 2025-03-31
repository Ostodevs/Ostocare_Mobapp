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
      return item.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query);
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
                  onPressed: () {
                    _searchController.clear();
                  },
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
            child: _isSearching ? _buildSuggestionsList() : _buildTrendingGrid(),
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

  Widget _buildTrendingGrid() {
    List<Map<String, String>> trendingData = [
      {'title': 'Trending 1', 'description': 'Latest news and updates', 'image': 'assets/Logoostocare.png',},
      {'title': 'Trending 2', 'description': 'Popular trends today', 'image': 'assets/Logoostocare.png'},
      {'title': 'Trending 3', 'description': 'Hot topics around', 'image': 'assets/Kings.png'},
      {'title': 'Trending 4', 'description': 'What’s buzzing now', 'image': 'assets/Lanka.png'},
      {'title': 'Trending 5', 'description': 'Most talked about', 'image': 'assets/Nawaloka.png'},
      {'title': 'Trending 6', 'description': 'Trending highlights', 'image': 'assets/Durdans.png'},
      {'title': 'Extra 1', 'description': 'More trends', 'image': 'assets/Hemas.png'},
      {'title': 'Extra 2', 'description': 'Latest updates', 'image': 'assets/surgi.png'},
      {'title': 'Extra 3', 'description': 'Hot news', 'image': 'assets/surgi1.png'},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StaggeredGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: List.generate(trendingData.length, (index) {
                int columnSpan = 1;
                int rowSpan = 1;

                if (index == 1 || index == 3 || index == 6) {
                  columnSpan = 2;
                  rowSpan = 2;
                }


                if (index >= 6) {
                  columnSpan = 1;
                  rowSpan = 1;
                }

                return StaggeredGridTile.count(
                  crossAxisCellCount: columnSpan,
                  mainAxisCellCount: rowSpan,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image: DecorationImage(
                        image: AssetImage(trendingData[index]['image']!),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${trendingData[index]['title']}\n${trendingData[index]['description']}',
                          style: TextStyle(
                            backgroundColor: Colors.transparent,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
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
