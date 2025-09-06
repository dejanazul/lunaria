import 'package:flutter/material.dart';

class DetailArtikelScreen extends StatefulWidget {
  final Map article;
  final bool isFav;
  final ValueChanged<bool>? onFav;

  const DetailArtikelScreen({
    super.key,
    required this.article,
    this.isFav = false,
    this.onFav,
  });

  @override
  State<DetailArtikelScreen> createState() => _DetailArtikelScreenState();
}

class _DetailArtikelScreenState extends State<DetailArtikelScreen> {
  late bool _isFav;
  bool _animating = false;

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFav;
  }

  void _toggleFav() async {
    setState(() => _animating = true);
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() {
      _isFav = !_isFav;
      _animating = false;
    });
    if (widget.onFav != null) widget.onFav!(_isFav);
  }

  @override
  void didUpdateWidget(covariant DetailArtikelScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFav != oldWidget.isFav) {
      _isFav = widget.isFav;
    }
  }

  String cleanContent(String? content) {
    if (content == null) return '-';
    return content.replaceAll(RegExp(r'\[\+\d+\schars\]'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Article',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AnimatedScale(
              scale: _animating ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 150),
              child: IconButton(
                icon: Icon(
                  _isFav ? Icons.favorite : Icons.favorite_border,
                  color: _isFav ? Color(0xFF913F9E) : Colors.grey,
                ),
                onPressed: _toggleFav,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                (() {
                  final img = article['urlToImage'] ?? article['image'] ?? '';
                  if (img.isNotEmpty) {
                    return Image.network(
                      img,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (c, e, s) => Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 60,
                            ),
                          ),
                    );
                  } else {
                    return Container(
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        color: Colors.grey,
                        size: 60,
                      ),
                    );
                  }
                })(),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'] ?? '',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
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
            ],
          ),
          const SizedBox(height: 16),
          if (article['summary'] != null &&
              article['summary'].toString().trim().isNotEmpty) ...[
            const Text(
              'Summary:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              article['summary'],
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
          ],
          Text(
            cleanContent(article['content']) != '-'
                ? cleanContent(article['content'])
                : (article['description'] ?? '-'),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
