import 'package:flutter/material.dart';
import 'detail_artikel.dart';

class FavArticleScreen extends StatelessWidget {
  final List<Map> favArticles;
  final Function(Map) onTapArticle;
  final Function(Map) onRemove;

  const FavArticleScreen({
    super.key,
    required this.favArticles,
    required this.onTapArticle,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Favorit Artikel',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
          favArticles.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada artikel favorit',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: favArticles.length,
                separatorBuilder: (c, i) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final article = favArticles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailArtikelScreen(article: article),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child:
                                (() {
                                  final img =
                                      article['urlToImage'] ??
                                      article['image'] ??
                                      '';
                                  if (img.isNotEmpty) {
                                    return Image.network(
                                      img,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (c, e, s) => Container(
                                            width: 90,
                                            height: 90,
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.image,
                                              color: Colors.grey,
                                              size: 40,
                                            ),
                                          ),
                                    );
                                  } else {
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    );
                                  }
                                })(),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article['title'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    article['publishedAt'] != null
                                        ? '${DateTime.parse(article['publishedAt']).day}/${DateTime.parse(article['publishedAt']).month}/${DateTime.parse(article['publishedAt']).year}'
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => onRemove(article),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
