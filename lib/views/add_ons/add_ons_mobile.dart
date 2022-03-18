part of add_ons_view;

class _AddOnsMobile extends StatelessWidget {
  final AddOnsViewModel viewModel;
  const _AddOnsMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(
        leading: SpPopButton(),
        title: SpAppBarTitle(),
      ),
      body: Consumer<GooglePayProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchProducts(),
            child: ListView.separated(
              padding: ConfigConstant.layoutPadding,
              itemCount: viewModel.productList.products.length,
              separatorBuilder: (context, index) => Divider(indent: kToolbarHeight - 8),
              itemBuilder: (context, index) {
                return ValueListenableBuilder<List<PurchaseDetails>>(
                  valueListenable: provider.purchaseNotifier,
                  builder: (context, purchaseDetails, child) {
                    // local product
                    ProductModel product = viewModel.productList.products[index];

                    // host product
                    Iterable<ProductDetails> result = provider.productDetails.where((e) => e.id == product.productId);
                    ProductDetails? productDetails = result.isNotEmpty ? result.first : null;

                    // purchase info
                    Iterable<PurchaseDetails> _purchaseDetails =
                        purchaseDetails.where((e) => e.productID == product.productId);
                    PurchaseDetails? streamDetails = _purchaseDetails.isNotEmpty ? _purchaseDetails.first : null;
                    IAPError? error = streamDetails?.error;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildProductTile(
                          context: context,
                          index: index,
                          product: product,
                          onBuy: () {
                            if (productDetails != null) {
                              provider.buyProduct(productDetails);
                            } else {
                              MessengerService.instance.showSnackBar("Product unavailble");
                            }
                          },
                        ),
                        SpCrossFade(
                          firstChild: buildMessage(context, streamDetails?.status.name.capitalize ?? ""),
                          secondChild: const SizedBox(width: double.infinity),
                          showFirst: streamDetails != null,
                        ),
                        SpCrossFade(
                          firstChild: buildMessage(context, error?.message ?? "", true),
                          secondChild: const SizedBox(width: double.infinity),
                          showFirst: error?.message != null,
                        ),
                        buildDebugger(productDetails)
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildDebugger(ProductDetails? productDetails) {
    return SpDeveloperVisibility(
      child: Container(
        margin: const EdgeInsets.only(left: kToolbarHeight - 8.0),
        child: Material(
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppHelper.prettifyJson(
                {
                  "id": productDetails?.id,
                  "title": productDetails?.title,
                  "description": productDetails?.description,
                  "price": productDetails?.price,
                  "rawPrice": productDetails?.rawPrice,
                  "currencyCode": productDetails?.currencyCode,
                  "currencySymbol": productDetails?.currencySymbol,
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMessage(
    BuildContext context,
    String message, [
    bool error = false,
  ]) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: kToolbarHeight - 8, bottom: ConfigConstant.margin0),
      padding: EdgeInsets.all(ConfigConstant.margin2),
      decoration: BoxDecoration(
        color: error ? M3Color.of(context).error : Theme.of(context).snackBarTheme.backgroundColor,
        borderRadius: ConfigConstant.circlarRadius1,
      ),
      child: Text(
        message,
        style: Theme.of(context).snackBarTheme.contentTextStyle?.copyWith(
              color: error ? M3Color.of(context).onError : null,
            ),
      ),
    );
  }

  Widget buildProductTile({
    required BuildContext context,
    required int index,
    required ProductModel product,
    required void Function() onBuy,
  }) {
    Color? backgroundColor = M3Color.dayColorsOf(context)[index % 6 + 1];
    Color foregroundColor = M3Color.of(context).onPrimary;
    BorderRadius circlarRadius = ConfigConstant.circlarRadius1;
    return Container(
      margin: const EdgeInsets.only(bottom: ConfigConstant.margin1),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            child: Icon(product.icon),
          ),
          ConfigConstant.sizedBoxW1,
          Expanded(
            child: SpPopupMenuButton(
              dyGetter: (dy) => dy + kToolbarHeight,
              dxGetter: (dx) => dx - 8.0,
              items: (context) {
                return [
                  SpPopMenuItem(
                    title: "Buy",
                    leadingIconData: Icons.payment,
                    onPressed: onBuy,
                  ),
                ];
              },
              builder: (callback) {
                return SpTapEffect(
                  onTap: callback,
                  effects: [SpTapEffectType.scaleDown],
                  child: Stack(
                    children: [
                      buildWaves(circlarRadius, backgroundColor, foregroundColor),
                      buildProductInfo(circlarRadius, product, foregroundColor, context, backgroundColor),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductInfo(
    BorderRadius circlarRadius,
    ProductModel product,
    Color foregroundColor,
    BuildContext context,
    Color? backgroundColor,
  ) {
    return ClipRRect(
      borderRadius: circlarRadius,
      child: MaterialBanner(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        elevation: 0.0,
        content: ListTile(
          title: Text(
            product.title,
            style: TextStyle(color: foregroundColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            product.description,
            style: TextStyle(color: foregroundColor),
            maxLines: 2,
          ),
          trailing: Text(
            product.price,
            style: M3TextTheme.of(context).titleLarge?.copyWith(color: foregroundColor),
          ),
        ),
        forceActionsBelow: true,
        actions: [
          Icon(
            Icons.more_vert,
            color: backgroundColor,
          ),
        ],
      ),
    );
  }

  Widget buildWaves(
    BorderRadius circlarRadius,
    Color? backgroundColor,
    Color foregroundColor,
  ) {
    return Positioned.fill(
      child: Material(
        borderRadius: circlarRadius,
        clipBehavior: Clip.hardEdge,
        elevation: 0.5,
        child: WaveWidget(
          backgroundColor: backgroundColor,
          config: CustomConfig(
            gradients: [
              [foregroundColor.withOpacity(0.2), foregroundColor.withOpacity(0.6)],
              [foregroundColor.withOpacity(0.3), foregroundColor.withOpacity(0.5)],
              [foregroundColor.withOpacity(0.4), foregroundColor.withOpacity(0.4)],
              [foregroundColor.withOpacity(0.5), foregroundColor.withOpacity(0.3)]
            ],
            durations: [35000, 19440, 10800, 6000],
            heightPercentages: [0.5, 0.55, 0.6, 0.65],
            gradientBegin: Alignment.bottomLeft,
            gradientEnd: Alignment.topRight,
          ),
          waveAmplitude: 0,
          size: Size(
            double.infinity,
            double.infinity,
          ),
        ),
      ),
    );
  }
}
