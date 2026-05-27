import 'package:flutter/material.dart';

import '../../../../../../core/ui/theme/custom_colors.dart';
import '../../../../../../core/utils/formatters.dart';
import '../../../../models/events.dart';
import '_event_detail_map_view_stub.dart'
    if (dart.library.html) '_event_detail_map_view_web.dart';

class EventDetailLocationSectionDesktopVersion extends StatefulWidget {
  final Events event;

  const EventDetailLocationSectionDesktopVersion({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailLocationSectionDesktopVersion> createState() =>
      _EventDetailLocationSectionDesktopVersionState();
}

class _EventDetailLocationSectionDesktopVersionState
    extends State<EventDetailLocationSectionDesktopVersion> {
  static int _instanceCounter = 0;
  late final String _viewType;
  late final bool _hasAddress;

  @override
  void initState() {
    super.initState();
    final address = widget.event.address;
    _hasAddress = address != null;

    if (_hasAddress) {
      _viewType = 'event-detail-map-desktop-${_instanceCounter++}';
      final query = formattedAddress(address!);
      final encodedQuery = Uri.encodeComponent(query);
      final mapUrl =
          'https://maps.google.com/maps?q=$encodedQuery&output=embed&hl=pt-BR';
      registerMapViewFactory(_viewType, mapUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = widget.event.address;
    final locationText = formattedLocation(address);
    final fullAddress = address != null ? formattedAddress(address) : '';
    final showLocationText =
        locationText.isNotEmpty && locationText != 'Local não informado';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 32, 48, 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(
                    'Local do Evento',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.fresh_sprout,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            CustomColors.fresh_sprout.withOpacity(0.4),
                            CustomColors.fresh_sprout.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showLocationText) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18,
                                color: CustomColors.concrete_mist,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  locationText,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: CustomColors.vanilla_haze,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (fullAddress.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 26),
                              child: Text(
                                fullAddress,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CustomColors.concrete_mist,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ] else
                          const Text(
                            'Local não informado',
                            style: TextStyle(
                              fontSize: 15,
                              color: CustomColors.concrete_mist,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 6,
                    child: _hasAddress
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 320,
                              child: buildMapView(_viewType),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
