import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/grocery-list/grocery_list_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/components/category_view.dart';
import 'package:grocery_flutter/pages/view/grocery_list_info/grocery_list_info_args.dart';
import 'package:grocery_flutter/models/grocery_list_item_display.dart';

class GroceryListInfoPage extends StatefulWidget {
  const GroceryListInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _GroceryListInfoPageState();
}

class _GroceryListInfoPageState extends State<GroceryListInfoPage> {
  late Map<String, List<GroceryListItemDisplay>>? items = null;
  CarouselSliderController carouselSliderController =
      CarouselSliderController();
  int _currentPage = 0;

  Map<String, List<GroceryListItemDisplay>> sortInBuckets(
    List<GroceryListItemDisplay> items,
  ) {
    Map<String, List<GroceryListItemDisplay>> out = {};
    for (var item in items) {
      if (out[item.categoryName] == null) {
        out[item.categoryName] = [item];
      } else {
        out[item.categoryName]?.add(item);
      }
    }
    return out;
  }

  refresh(GroceryListController controller, GroceryListInfoArgs args) {
    controller.getListInfo(args.list.listId).then((value) {
      if (value is RequestSuccess<List<GroceryListItemDisplay>?>) {
        setState(() {
          items = sortInBuckets((value as RequestSuccess).result);
        });
      } else if (value is RequestError<List<GroceryListItemDisplay>>) {
        Fluttertoast.showToast(msg: (value as RequestError).error);
      } else {
        Fluttertoast.showToast(msg: "Returned value of unknown type");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as GroceryListInfoArgs;
    GroceryListController controller = GroceryListController(jwt: args.jwt);
    if (items == null) refresh(controller, args);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Grocery list"),
        actions: [
          IconButton(
            //TODO: confirm??????
            onPressed: () async {
              var result = await controller.deleteList(args.list.listId);
              if (result is RequestSuccess) {
                if (context.mounted) {
                  Navigator.of(
                    context,
                  ).popAndPushNamed('/home', arguments: args.jwt);
                }
              } else if (result is RequestError) {
                Fluttertoast.showToast(msg: result.toString());
              } else {
                Fluttertoast.showToast(msg: result.toString());
              }
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body:
          items == null
              ? Center(child: CircularProgressIndicator())
              : items?.isEmpty ?? true
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 72),
                    Text("Empty cart"),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: CarouselSlider(
                      carouselController: carouselSliderController,
                      items:
                          items!.entries
                              .map(
                                (entry) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: CategoryView(items: entry),
                                ),
                              )
                              .toList(),
                      options: CarouselOptions(
                        scrollPhysics: PageScrollPhysics(),
                        enlargeCenterPage: true,
                        animateToClosest: false,
                        viewportFraction: 0.95,
                        height: 600,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(11)),
                      ),
                      color:
                          Theme.of(
                            context,
                          ).buttonTheme.colorScheme!.onSecondary,
                    ),
                    child: DotsIndicator(
                      dotsCount:
                          items != null && items!.isNotEmpty
                              ? items!.length
                              : 1,
                      position: _currentPage.toDouble(),
                      onTap:
                          (position) =>
                              carouselSliderController.animateToPage(position),

                      decorator: DotsDecorator(
                        activeColor: Theme.of(context).colorScheme.primary,
                        size: Size.square(8.0),
                        activeSize: Size.square(12.0),
                      ),
                    ),
                  ),
                  SizedBox.square(dimension: 20),
                ],
              ),
    );
  }
}
