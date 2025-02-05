import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../common_widgets.dart/custom_alert_dialog.dart';
import '../../common_widgets.dart/custom_search.dart';
import '../../util/check_login.dart';
import 'collage_bloc/collage_bloc.dart';
import 'collage_details.dart';
import 'custom_collage_card.dart';

class Collages extends StatefulWidget {
  const Collages({super.key});

  @override
  State<Collages> createState() => _CollagesState();
}

class _CollagesState extends State<Collages> {
  final CollagesBloc _collagesBloc = CollagesBloc();

  Map<String, dynamic> params = {
    'query': null,
  };

  List<Map> _collages = [];

  @override
  void initState() {
    checkLogin(context);
    getCollages();
    super.initState();
  }

  void getCollages() {
    _collagesBloc.add(GetAllCollagesEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _collagesBloc,
      child: BlocConsumer<CollagesBloc, CollagesState>(
        listener: (context, state) {
          if (state is CollagesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getCollages();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CollagesGetSuccessState) {
            _collages = state.collages;
            Logger().w(_collages);
            setState(() {});
          } else if (state is CollagesSuccessState) {
            getCollages();
          }
        },
        builder: (context, state) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Text(
                "Colleges",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomSearch(
                onSearch: (search) {
                  params['query'] = search;
                  getCollages();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              if (state is CollagesLoadingState)
                const Center(child: CircularProgressIndicator()),
              if (_collages.isEmpty && state is! CollagesLoadingState)
                const Center(child: Text("No College Found")),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                children: List.generate(
                  _collages.length,
                  (index) => CustomCollageCard(
                    coverImageUrl: _collages[index]['cover_page'],
                    name: _collages[index]['name'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CollageDetailsScreen(
                            collageId: _collages[index]['id'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
