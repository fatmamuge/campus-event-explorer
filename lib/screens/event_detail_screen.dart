import 'package:flutter/material.dart';
import '../models/event.dart';
import 'image_viewer_screen.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  final VoidCallback onFavoriteToggle;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.onFavoriteToggle,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  // Katilma Onay Diyalogu (Join Confirmation Dialog)
  Future<void> _showJoinConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Participation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to join this event?'),
              const SizedBox(height: 12),
              Text(
                widget.event.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Date: ${widget.event.dateTime.day}.${widget.event.dateTime.month}.${widget.event.dateTime.year} - ${widget.event.dateTime.hour.toString().padLeft(2, '0')}:${widget.event.dateTime.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                'Venue: ${widget.event.venue}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        widget.event.isJoined = true;
        widget.event.availablePlaces -= 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined "${widget.event.title}"!'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Katilimi Iptal Etme Onay Diyalogu (Cancel Participation Dialog)
  Future<void> _showCancelConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Participation'),
          content: Text(
            'Are you sure you want to cancel your participation in "${widget.event.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        widget.event.isJoined = false;
        widget.event.availablePlaces += 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cancelled participation in "${widget.event.title}".'),
          backgroundColor: Colors.orange.shade800,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Cift tiklama ile buyuk resmi acma (Double-tap to open enlarged image)
  void _openImageViewer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(
          imagePath: widget.event.imagePath,
          title: widget.event.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = widget.event;

    final String availabilityText = event.isFull
        ? 'Full'
        : '${event.availablePlaces} / ${event.totalCapacity} places available';

    final Color availabilityColor =
        event.isFull ? Colors.red.shade700 : Colors.green.shade700;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFA3082C),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              event.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: event.isFavorite ? Colors.redAccent.shade100 : Colors.white,
            ),
            onPressed: () {
              widget.onFavoriteToggle();
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cift tiklanabilir gorsel alani (GestureDetector double-tap)
            GestureDetector(
              onDoubleTap: _openImageViewer,
              child: Stack(
                children: [
                  Image.asset(
                    event.imagePath,
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 240,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.zoom_in, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Double tap to enlarge',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori ve Durum Etiketleri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(
                          event.category,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: availabilityColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: availabilityColor),
                        ),
                        child: Text(
                          availabilityText,
                          style: TextStyle(
                            color: availabilityColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Baslik
                  Text(
                    event.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tarih / Saat Karti
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(child: Icon(Icons.calendar_month)),
                    title: const Text('Date & Time'),
                    subtitle: Text(
                      '${event.dateTime.day}.${event.dateTime.month}.${event.dateTime.year} at ${event.dateTime.hour.toString().padLeft(2, '0')}:${event.dateTime.minute.toString().padLeft(2, '0')}',
                    ),
                  ),

                  // Mekan Karti
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(child: Icon(Icons.location_on)),
                    title: const Text('Venue'),
                    subtitle: Text(event.venue),
                  ),

                  const Divider(height: 32),

                  // Aciklama
                  Text(
                    'About Event',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Katilma / Iptal Etme Butonu (Join / Cancel Button Logic)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Builder(
                      builder: (context) {
                        if (event.isJoined) {
                          return OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                              side: BorderSide(color: Colors.red.shade700),
                            ),
                            onPressed: _showCancelConfirmationDialog,
                            icon: const Icon(Icons.cancel_outlined),
                            label: const Text(
                              'Cancel Participation',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                        } else if (event.isFull) {
                          return FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.grey.shade400,
                            ),
                            onPressed: null, // Buton pasif (Full durumu)
                            icon: const Icon(Icons.block),
                            label: const Text(
                              'Event is Full',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        } else {
                          return FilledButton.icon(
                            onPressed: _showJoinConfirmationDialog,
                            icon: const Icon(Icons.how_to_reg),
                            label: const Text(
                              'Join Event',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
