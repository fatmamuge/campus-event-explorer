import 'package:flutter/material.dart';
import '../data/mock_events.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Bellek ici etkinlik listesi (in-memory state)
  late List<Event> _events;

  // Aktif sekme indeksi (0: Explore, 1: Favorites, 2: My Events)
  int _currentTabIndex = 0;

  // Arama metni ve kategori filtreleri
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = ['All', 'Technology', 'Arts', 'Sports','Career','Music'];

  @override
  void initState() {
    super.initState();
    _events = List.from(initialEvents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Toplam katilinan etkinlik sayisi (total joined events counter)
  int get _joinedEventsCount => _events.where((e) => e.isJoined).length;

  // Favori durumunu degistirme (toggle favorite)
  void _toggleFavorite(Event event) {
    setState(() {
      event.isFavorite = !event.isFavorite;
    });
  }

  // Arama ve kategori filtrelerine gore filtrelenmis liste
  List<Event> _getFilteredEvents() {
    // 1. Sekmeye gore ana havuzu belirle
    List<Event> baseList;
    if (_currentTabIndex == 1) {
      baseList = _events.where((e) => e.isFavorite).toList();
    } else if (_currentTabIndex == 2) {
      baseList = _events.where((e) => e.isJoined).toList();
    } else {
      baseList = _events;
    }

    // 2. Arama ve Kategori filtrelerini birlikte uygula (case-insensitive & trimmed)
    final cleanQuery = _searchQuery.trim().toLowerCase();

    return baseList.where((event) {
      final matchesSearch = cleanQuery.isEmpty ||
          event.title.toLowerCase().contains(cleanQuery);
      final matchesCategory = _selectedCategory == 'All' ||
          event.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Detay ekranina gecis ve donuste state guncelleme
  Future<void> _openDetail(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(
          event: event,
          onFavoriteToggle: () => _toggleFavorite(event),
        ),
      ),
    );
    // Detay ekranindan geri donuldugunde arayuzu aninda tazele
    setState(() {});
  }

  // Arama ve filtreleri sifirlama
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayedEvents = _getFilteredEvents();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            // ESTU Logosu
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/estu_logo.png',
                height: 36,
                width: 36,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text(
                      'ESTÜ',
                      style: TextStyle(
                        color: Color(0xFFA3082C),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ESTÜ Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Campus Event Explorer',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      'Joined: $_joinedEventsCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Arama Cubugu (Search Bar)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events by title...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // 2. Kategori Filtre Butonlari (Category Chips)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // 3. Eslesen Sonuc Sayisi (Matching Events Count)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Showing ${displayedEvents.length} events',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // 4. Etkinlik Listesi veya Bos Durum (List View or Empty State)
          Expanded(
            child: displayedEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: displayedEvents.length,
                    itemBuilder: (context, index) {
                      final event = displayedEvents[index];
                      return EventCard(
                        event: event,
                        onTap: () => _openDetail(event),
                        onFavoriteToggle: () => _toggleFavorite(event),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'My Events',
          ),
        ],
      ),
    );
  }

  // Bos Durum Bileseni (Empty State Widget)
  // Bos Durum Bileseni (Empty State Widget - Overflow korumali)
  Widget _buildEmptyState() {
    String message = 'No events found matching your criteria.';
    if (_currentTabIndex == 1 && _events.where((e) => e.isFavorite).isEmpty) {
      message = 'You have not added any favorite events yet.';
    } else if (_currentTabIndex == 2 && _events.where((e) => e.isJoined).isEmpty) {
      message = 'You have not joined any campus events yet.';
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _clearSearch,
              icon: const Icon(Icons.refresh),
              label: const Text('Clear Filters & Search'),
            ),
          ],
        ),
      ),
    );
  }
}
