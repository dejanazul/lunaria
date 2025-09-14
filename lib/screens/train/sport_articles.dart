import 'package:flutter/material.dart';
import '../../services/news_api_service.dart';
import 'detail_artikel.dart';

class SportArticlesScreen extends StatefulWidget {
  const SportArticlesScreen({super.key});

  @override
  State<SportArticlesScreen> createState() => _SportArticlesScreenState();
}

class _SportArticlesScreenState extends State<SportArticlesScreen> {
  String _search = '';
  final Set<String> _favorites = {};
  List<Map<String, dynamic>> _articles = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await NewsApiService.fetchArticles(
        keywords: ['sport', 'health', 'women', 'menstruation', 'menstrual'],
        language: 'en',
        pageSize: 20,
      );
      setState(() {
        _articles = result as List<Map<String, dynamic>>;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filtered {
    if (_search.isEmpty) return _articles;
    return _articles
        .where(
          (a) =>
              (a['title'] ?? '').toLowerCase().contains(_search.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sport Article',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              final favArticles =
                  _articles
                      .where((a) => _favorites.contains(a['url']))
                      .toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => FavArticleScreen(
                        articles: favArticles,
                        onTapArticle: (article) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => DetailArtikelScreen(article: article),
                            ),
                          );
                        },
                        onRemove: (article) {
                          setState(() {
                            _favorites.remove(article['url']);
                          });
                        },
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal memuat berita.\n$_error',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchNews,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5E5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              onChanged: (v) => setState(() => _search = v),
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        filtered.isEmpty
                            ? const Center(
                              child: Text(
                                'Tidak ada berita ditemukan.',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final article = filtered[index];
                                final isFav = _favorites.contains(
                                  article['url'],
                                );
                                Widget imageWidget;
                                final urlToImage = article['urlToImage'] ?? '';
                                if (urlToImage.isNotEmpty) {
                                  imageWidget = Image.network(
                                    urlToImage,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (c, e, s) => Image.asset(
                                          'assets/images/pet_main_image.png',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                  );
                                } else {
                                  imageWidget = Image.asset(
                                    'assets/images/pet_main_image.png',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  );
                                }
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: imageWidget,
                                    ),
                                    title: Text(
                                      article['title'] ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    subtitle: Text(
                                      article['publishedAt'] != null
                                          ? '${DateTime.tryParse(article['publishedAt'] ?? '')?.day ?? ''}/${DateTime.tryParse(article['publishedAt'] ?? '')?.month ?? ''}/${DateTime.tryParse(article['publishedAt'] ?? '')?.year ?? ''}'
                                          : '',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            isFav
                                                ? Color(0xFF913F9E)
                                                : Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isFav) {
                                            _favorites.remove(article['url']);
                                          } else {
                                            _favorites.add(article['url']);
                                          }
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => DetailArtikelScreen(
                                                article: article,
                                                isFav: _favorites.contains(
                                                  article['url'],
                                                ),
                                                onFav: (fav) {
                                                  setState(() {
                                                    if (fav) {
                                                      _favorites.add(
                                                        article['url'],
                                                      );
                                                    } else {
                                                      _favorites.remove(
                                                        article['url'],
                                                      );
                                                    }
                                                  });
                                                },
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}

class FavArticleScreen extends StatelessWidget {
  final List<dynamic> articles;
  final Function(Map<String, dynamic>)? onTapArticle;
  final Function(Map<String, dynamic>)? onRemove;
  const FavArticleScreen({
    super.key,
    required this.articles,
    this.onTapArticle,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Article Bookmarks',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child:
                    (() {
                      final urlToImage = article['urlToImage'] ?? '';
                      if (urlToImage.isNotEmpty) {
                        return Image.network(
                          urlToImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (c, e, s) => Image.asset(
                                'assets/images/pet_main_image.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                        );
                      } else {
                        return Image.asset(
                          'assets/images/pet_main_image.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        );
                      }
                    })(),
              ),
              title: Text(
                article['title'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              subtitle: const Text(
                '3 min read',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
              trailing: const Icon(Icons.favorite, color: Color(0xFF913F9E)),
              onTap: () {
                if (onTapArticle != null) {
                  onTapArticle!(article);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
