import 'package:idigital_costumer/Helper/Color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../Helper/String.dart';
import '../../../Helper/routes.dart';
import '../../../Model/Order_Model.dart';
import '../../../widgets/snackbar.dart';
import '../../Language/languageSettings.dart';
import 'ProductItemdata.dart';

class GetSingleProduct extends StatelessWidget {
  OrderModel model;
  String activeStatus;
  String id;
  Function updateNow;

  GetSingleProduct({
    Key? key,
    required this.id,
    required this.activeStatus,
    required this.model,
    required this.updateNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = 0;

    List<String> getAllSellerId =
        model.itemList!.map((question) => question.seller_id!).toSet().toList();

    print('getAllSellerId****$getAllSellerId');

    return ListView.builder(
      shrinkWrap: true,
      itemCount: model.itemList!.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        var orderItem = model.itemList![i];
        print('Active status****$activeStatus***${orderItem.status}********$i');

        if (activeStatus != '') {
          if (orderItem.status == activeStatus) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: getAllSellerId.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, j) {
                  print(
                      'order_item seller****${orderItem.seller_id}******${getAllSellerId[j]}');
                  if (orderItem.seller_id == getAllSellerId[j]) {
                    return ExpansionPanelList.radio(
                      children: [
                        ExpansionPanelRadio(
                          body: ProductItemWidget(
                            orderItem: orderItem,
                            model: model,
                            id: id,
                            updateNow: updateNow,
                          ),
                          headerBuilder: (context, isExpanded) {
                            return Row(children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${getTranslated(context, "STORE_NAME")!} : ",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .lightBlack,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${getTranslated(context, "OTP")!} : ",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .lightBlack,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    orderItem.courier_agency! != ''
                                        ? Text(
                                            "${getTranslated(context, 'COURIER_AGENCY')!}: ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .lightBlack,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container(),
                                    orderItem.tracking_id! != ''
                                        ? Text(
                                            "${getTranslated(context, 'TRACKING_ID')!}: ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .lightBlack,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        '${orderItem.store_name}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .lightBlack2,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onTap: () {
                                        Routes.navigateToSellerProfileScreen(
                                          context,
                                          orderItem.seller_id,
                                          orderItem.seller_profile,
                                          orderItem.seller_name,
                                          orderItem.seller_rating,
                                          orderItem.seller_name,
                                          orderItem.store_description,
                                          '0',
                                        );
                                      },
                                    ),
                                    Text(
                                      '${orderItem.item_otp} ',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .lightBlack2,
                                      ),
                                    ),
                                    orderItem.courier_agency! != ''
                                        ? Text(
                                            orderItem.courier_agency!,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .lightBlack2,
                                            ),
                                          )
                                        : Container(),
                                    orderItem.tracking_id! != ''
                                        ? RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .lightBlack,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                  text: orderItem.tracking_id!,
                                                  style: const TextStyle(
                                                      color: colors.primary,
                                                      decoration: TextDecoration
                                                          .underline),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          var url =
                                                              '${orderItem.tracking_url}';

                                                          if (await canLaunchUrlString(
                                                              url)) {
                                                            await launchUrlString(
                                                                url);
                                                          } else {
                                                            setSnackbar(
                                                                getTranslated(
                                                                    context,
                                                                    'URL_ERROR')!,
                                                                context);
                                                          }
                                                        },
                                                )
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              )
                            ]);
                          },
                          value: j,
                          canTapOnHeader: false,
                        ),
                      ],
                      elevation: 0.0,
                      animationDuration: const Duration(milliseconds: 700),
                      expansionCallback: (int item, bool status) {
                        /*  setState(
                      () {*/
                        orderItem.isExpanded = status;
                        /* },
                    );*/
                      },
                    );
                  }
                  return const SizedBox();
                });
          }
          if ((orderItem.status == SHIPED || orderItem.status == PLACED) &&
              activeStatus == PROCESSED) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: getAllSellerId.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, j) {
                  if (orderItem.seller_id == getAllSellerId[j]) {
                    return ProductItemWidget(
                      orderItem: orderItem,
                      model: model,
                      id: id,
                      updateNow: updateNow,
                    );
                  }
                  return const SizedBox();
                });
          }
        } else {
          return ProductItemWidget(
            orderItem: orderItem,
            model: model,
            id: id,
            updateNow: updateNow,
          );
        }

        count++;
        if (count == model.itemList!.length) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Center(
              child: Text(
                getTranslated(context, 'noItem')!,
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
