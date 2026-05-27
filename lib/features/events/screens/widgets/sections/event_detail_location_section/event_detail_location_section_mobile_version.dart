import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/utils/formatters.dart';
import '../../../../models/events.dart';
import '_event_detail_map_view_stub.dart'
    if (dart.library.html) '_event_detail_map_view_web.dart';

class EventDetailLocationSectionMobileVersion extends StatefulWidget {
  final Events event;

  const EventDetailLocationSectionMobileVersion({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailLocationSectionMobileVersion> createState() =>
      _EventDetailLocationSectionMobileVersionState();
}

class _EventDetailLocationSectionMobileVersionState
    extends State<EventDetailLocationSectionMobileVersion> {
  static int _instanceCounter = 0;
  late final String _viewType;
  late final bool _hasAddress;

  @override
  void initState() {
    super.initState();
    final address = widget.event.address;
    _hasAddress = address != null;

    if (_hasAddress) {
      _viewType = 'event-detail-map-${_instanceCounter++}';
      final query = formattedAddress(address!);
      final encodedQuery = Uri.encodeComponent(query);
      final mapUrl =
          'https://maps.google.com/maps?q=$encodedQuery&output=embed&hl=pt-BR';
      registerMapViewFactory(_viewType, mapUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationText = formattedLocation(widget.event.address);
    final showLocationText =
        locationText.isNotEmpty && locationText != 'Local não informado';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Local do Evento',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CustomColors.fresh_sprout,
              fontFamily: 'RobotoSlab',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (showLocationText) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: CustomColors.concrete_mist,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    locationText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CustomColors.concrete_mist,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          if (_hasAddress) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 240,
                child: buildMapView(_viewType),
              ),
            ),
          ] else
            const Text(
              'Local não informado',
              style: TextStyle(
                fontSize: 14,
                color: CustomColors.concrete_mist,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
