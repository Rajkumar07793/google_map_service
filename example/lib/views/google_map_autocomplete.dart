import 'package:example/bloc/map_bloc/map_bloc.dart';
import 'package:example/bloc/map_bloc/map_event.dart';
import 'package:example/bloc/map_bloc/map_state.dart';
import 'package:example/bloc/selection_bloc/selection_bloc.dart';
import 'package:example/bloc/selection_bloc/selection_event.dart';
import 'package:example/bloc/selection_bloc/selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleMapAutocomplete extends StatefulWidget {
  final bool isSource;
  const GoogleMapAutocomplete({super.key, this.isSource = false});

  @override
  State<GoogleMapAutocomplete> createState() => _GoogleMapAutocompleteState();
}

class _GoogleMapAutocompleteState extends State<GoogleMapAutocomplete> {
  final SelectionBloc showCancelBtnBloc = SelectionBloc(SelectBoolState(false));
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final arg = args(context) as GoogleMapAutocomplete?;
      bool isSource = widget.isSource;
      final mapBloc = context.read<MapBloc>();
      final source = mapBloc.source;
      final destination = mapBloc.destination;
      _controller.text = isSource
          ? source?.name ?? source?.formattedAddress ?? ""
          : destination?.name ?? destination?.formattedAddress ?? "";
      mapBloc.add(SearchGooglePlaces(query: _controller.text));
      showCancelBtnBloc.add(SelectBoolEvent(_controller.text.isNotEmpty));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final arg = args(context) as GoogleMapAutocomplete?;
    bool isSource = widget.isSource;
    return Scaffold(
      appBar: AppBar(
        // title: Text(isSource ? "Choose source" : "Choose destination"),
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText:
                "Search ${isSource ? 'for source...' : 'for destination...'}",
            // suffix: const Icon(Icons.search),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(12),
            //   // ),
            suffix: BlocBuilder(
              bloc: showCancelBtnBloc,
              builder: (context, state) {
                if (state is SelectBoolState && state.value) {
                  return InkWell(
                    onTap: () {
                      _controller.clear();
                      context.read<MapBloc>().add(
                        SearchGooglePlaces(query: ""),
                      );
                      showCancelBtnBloc.add(SelectBoolEvent(false));
                    },
                    child: const Icon(Icons.close, color: Colors.grey),
                  );
                }
                return const Icon(Icons.search, color: Colors.grey);
              },
            ),
          ),
          onChanged: (value) {
            context.read<MapBloc>().add(SearchGooglePlaces(query: value));
            showCancelBtnBloc.add(SelectBoolEvent(value.isNotEmpty));
          },
        ),
        // backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          final predictions = state.places?.predictions ?? [];
          return ListView.builder(
            itemCount: predictions.length,
            itemBuilder: (context, index) {
              final place = predictions[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.red),
                  // title: Text(place.description ?? ""),
                  title: Text(place.structuredFormatting?.mainText ?? ""),
                  subtitle: Text(
                    place.structuredFormatting?.secondaryText ?? "",
                  ),
                  onTap: () {
                    if (isSource) {
                      context.read<MapBloc>().add(SelectSourceEvent(place));
                    } else {
                      context.read<MapBloc>().add(
                        SelectDestinationEvent(place),
                      );
                    }
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
