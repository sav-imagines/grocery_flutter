import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_flutter/http/grocery-list/grocery_list_controller.dart';
import 'package:grocery_flutter/http/item/item_controller.dart';
import 'package:grocery_flutter/http/social/request_result.dart';
import 'package:grocery_flutter/components/other_category_view.dart';
import 'package:grocery_flutter/models/short_item.dart';
import 'package:grocery_flutter/pages/simple_forms/create_list_item/create_list_item_args.dart';
import 'package:grocery_flutter/models/category_model.dart';
import 'package:grocery_flutter/pages/complex_forms/create_list/create_list_args.dart';

class CreateListPage extends StatefulWidget {
  const CreateListPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  late List<CategoryModel>? items = null;
  late int _currentPage = 0;
  final CarouselSliderController carouselController =
      CarouselSliderController();
  bool shouldJump = true;

  refresh(ItemController controller) {
    var result = controller.getItemsInGroup();
    result.then((value) {
      if (value is RequestSuccess) {
        value = value as RequestSuccess<List<CategoryModel>?>;
        setState(() {
          items = (value as RequestSuccess).result;
        });
      } else if (value is RequestError) {
        Fluttertoast.showToast(msg: (value as RequestError).error);
      } else {
        Fluttertoast.showToast(msg: "Invalid type");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CreateListArgs;
    ItemController controller = ItemController(jwt: args.jwt);
    if (args.items != null && items == null) {
      items = args.items;
    } else if (items == null) {
      refresh(controller);
    }
    if (shouldJump && args.index == 0) {
      setState(() => shouldJump = false);
    }
    if (shouldJump) {
      carouselController.onReady.then<void>((_) {
        carouselController.jumpToPage(args.index);
        setState(() {
          shouldJump = false;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("New grocery list"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed('/create-category', arguments: args.jwt);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child:
            items == null
                ? const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text("Fetching items..."),
                    ],
                  ),
                )
                : Column(
                  children: [
                    CarouselSlider(
                      carouselController: carouselController,
                      items:
                          items!
                              .map<Widget>(
                                (category) => Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(11),
                                        ),
                                      ),
                                      color:
                                          Theme.of(context)
                                              .buttonTheme
                                              .colorScheme!
                                              .onSecondary,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              category.name,
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.headlineSmall,
                                            ),
                                            Spacer(),
                                            IconButton(
                                              onPressed: () async {
                                                await Navigator.of(
                                                  context,
                                                ).pushNamed(
                                                  '/create-list-item',
                                                  arguments: CreateItemArgs(
                                                    jwt: args.jwt,
                                                    categoryId: category.id,
                                                    items: items,
                                                    index: _currentPage,
                                                  ),
                                                );
                                                refresh(controller);
                                              },
                                              icon: Icon(Icons.add),
                                            ),
                                          ],
                                        ),
                                        CategoryView(
                                          items: category.items,
                                          changeQuantity:
                                              (ShortItem item, int quantity) =>
                                                  setState(
                                                    () =>
                                                        category.changeQuantity(
                                                          item,
                                                          quantity,
                                                        ),
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .followedBy([
                                Column(
                                  children: [
                                    Text(
                                      "Submit",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.headlineMedium,
                                    ),
                                    Text("Items:"),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children:
                                          items!
                                              .map<Widget>(
                                                (category) => Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children:
                                                      category.items
                                                          .where(
                                                            (item) =>
                                                                item.quantity >
                                                                0,
                                                          )
                                                          .map(
                                                            (item) => Text(
                                                              item.name +
                                                                  (item.quantity >
                                                                          1
                                                                      ? " (${item.quantity})"
                                                                      : ""),
                                                            ),
                                                          )
                                                          .toList(),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    FilledButton(
                                      onPressed: () async {
                                        var result =
                                            await GroceryListController(
                                              jwt: controller.jwt,
                                            ).createList(items!);
                                        if (result is RequestSuccess) {
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        } else if (result is RequestError) {
                                          Fluttertoast.showToast(
                                            msg: result.error,
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Submit",
                                            style: TextStyle(
                                              fontStyle:
                                                  Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .fontStyle,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.surface,
                                            ),
                                          ),
                                          SizedBox.square(dimension: 10),
                                          Icon(Icons.send),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ])
                              .toList(),
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        animateToClosest: true,
                        viewportFraction: 0.98,
                        height: 600,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                    ),
                    SizedBox.square(dimension: 12),
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
                        dotsCount: items!.length + 1,
                        position: _currentPage.toDouble(),
                        onTap:
                            (position) =>
                                carouselController.animateToPage(position),

                        decorator: DotsDecorator(
                          activeColor: Theme.of(context).colorScheme.primary,
                          size: Size.square(8.0),
                          activeSize: Size.square(12.0),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
