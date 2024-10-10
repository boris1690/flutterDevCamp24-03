import 'package:flutter/material.dart';
import 'package:flutter_api/normal_http/api/dbz_service.dart';
import 'package:flutter_api/normal_http/model/character.dart';
import 'package:flutter_api/normal_http/model/response_data.dart';

class ViewCharactersPage extends StatefulWidget {
  const ViewCharactersPage({super.key});

  @override
  State<ViewCharactersPage> createState() => _ViewCharactersPageState();
}

class _ViewCharactersPageState extends State<ViewCharactersPage> {
  final DbzService _dbzService = DbzService();
  late Future<ResponseData> futureCharacters;
  final ScrollController _scrollController = ScrollController();
  final List<Character> _characters = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _fetchCharacters();
    }
  }

  Future<void> _fetchCharacters() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dbzService.fetchCharacters(page: _currentPage);
      setState(() {
        _characters.addAll(response.data);
        _currentPage++;
        _hasMore = response.data.isNotEmpty;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _calculateScale(int index) {
    double itemPosition =
        index * 450.0; // Assuming each item has a height of 450
    double viewportCenter =
        _scrollPosition + (MediaQuery.of(context).size.height / 3);
    double difference = (itemPosition - viewportCenter).abs();

    // Only apply zoom if the item is within a certain range of the center of the viewport
    if (difference < 225) {
      // Adjust this value based on the height of the item
      double scale = 1.0 +
          (1 -
              (difference /
                  225)); // Adjust the divisor to control the zoom effect
      return scale.clamp(1.0, 1.4); // Clamp the scale between 1.0 and 2.0
    } else {
      return 1.0; // Normal scale
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dragon Ball Z Characters')),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !_isLoading) {
            _fetchCharacters();
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _characters.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _characters.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final character = _characters[index];
            double scale = _calculateScale(index);
            return CharacterCard(character: character, scale: scale);
          },
        ),
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;
  final double scale;

  const CharacterCard(
      {super.key, required this.character, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E), // Dark background for the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: 300,
        height: 450,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Character Image
            Transform.scale(
              scale: scale,
              child: Image.network(
                character.image,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            // Character Name
            Text(
              character.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            // Character Info
            Text(
              '${character.race} - ${character.gender}',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16.0),
            // Base KI
            _buildInfoRow('Base KI:', character.ki),
            const SizedBox(height: 8.0),
            // Total KI
            _buildInfoRow('Total KI:', character.maxKi),
            const SizedBox(height: 8.0),
            // Affiliation
            _buildInfoRow('Affiliation:', character.affiliation),
          ],
        ),
      ),
    );
  }

  // Helper function to build info rows
  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.amber,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
