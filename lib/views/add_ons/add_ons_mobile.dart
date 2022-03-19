part of add_ons_view;

class _AddOnsMobile extends StatelessWidget {
  final AddOnsViewModel viewModel;
  const _AddOnsMobile(this.viewModel);

  double get expandedHeight => 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GooglePayProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchProducts(),
            displacement: expandedHeight / 2,
            child: CustomScrollView(
              slivers: [
                SpExpandedAppBar(
                  expandedHeight: expandedHeight,
                  actions: [],
                ),
                SliverPadding(
                  padding: ConfigConstant.layoutPadding,
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ValueListenableBuilder<List<PurchaseDetails>>(
                          valueListenable: provider.purchaseNotifier,
                          builder: (context, purchaseDetails, child) {
                            return buildWholeCard(
                              index: index,
                              provider: provider,
                              purchaseDetails: purchaseDetails,
                              context: context,
                            );
                          },
                        );
                      },
                      childCount: viewModel.productList.products.length,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildWholeCard({
    required int index,
    required GooglePayProvider provider,
    required List<PurchaseDetails> purchaseDetails,
    required BuildContext context,
  }) {
    // local product
    ProductModel product = viewModel.productList.products[index];

    // hosted product
    Iterable<ProductDetails> result = provider.productDetails.where((e) => e.id == product.productId);
    ProductDetails? productDetails = result.isNotEmpty ? result.first : null;

    // purchase info
    Iterable<PurchaseDetails> _purchaseDetails = purchaseDetails.where((e) => e.productID == product.productId);
    PurchaseDetails? streamDetails = _purchaseDetails.isNotEmpty ? _purchaseDetails.first : null;
    IAPError? error = streamDetails?.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildProductTile(
          leadingIconData: product.icon,
          context: context,
          index: index,
          title: product.title,
          subtitle: productDetails?.description ?? product.description,
          price: product.price,
          onBuyPressed: () {
            if (productDetails != null) {
              provider.buyProduct(productDetails);
            } else {
              MessengerService.instance.showSnackBar("Product unavailble");
            }
          },
          onTryPressed: () {
            product.onTryPressed();
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
    required IconData leadingIconData,
    required String title,
    required String subtitle,
    required String? price,
    required void Function() onBuyPressed,
    required void Function() onTryPressed,
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
            child: Icon(leadingIconData),
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
                    onPressed: onBuyPressed,
                    titleStyle: TextStyle(color: backgroundColor),
                  ),
                  SpPopMenuItem(
                    title: "Try",
                    leadingIconData: Icons.play_arrow,
                    onPressed: onTryPressed,
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
                      buildProductInfo(
                        circlarRadius: circlarRadius,
                        title: title,
                        subtitle: subtitle,
                        foregroundColor: foregroundColor,
                        context: context,
                        backgroundColor: backgroundColor,
                        price: price,
                      ),
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

  Widget buildProductInfo({
    required BorderRadius circlarRadius,
    required String title,
    required String subtitle,
    required String? price,
    required Color foregroundColor,
    required BuildContext context,
    required Color? backgroundColor,
  }) {
    return ClipRRect(
      borderRadius: circlarRadius,
      child: MaterialBanner(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        elevation: 0.0,
        content: ListTile(
          contentPadding: const EdgeInsets.only(right: ConfigConstant.margin2),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
            child: Text(
              title,
              style: TextStyle(color: foregroundColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Stack(
            children: [
              Text("", style: TextStyle(color: foregroundColor), maxLines: 1),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: ConfigConstant.margin2),
                child: Text(
                  subtitle,
                  style: TextStyle(color: foregroundColor),
                  maxLines: 1,
                ),
              ),
              buildTextFade(backgroundColor, true),
              buildTextFade(backgroundColor, false),
            ],
          ),
          trailing: SpCrossFade(
            showFirst: price == null,
            firstChild: Text(
              price ?? "",
              style: M3TextTheme.of(context).titleLarge?.copyWith(color: foregroundColor),
            ),
            secondChild: Text(
              price ?? "",
              style: M3TextTheme.of(context).titleLarge?.copyWith(color: foregroundColor),
            ),
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

  Widget buildTextFade(Color? backgroundColor, [bool rtl = true]) {
    List<Color> colors = [
      backgroundColor ?? Colors.transparent,
      backgroundColor?.withOpacity(0.9) ?? Colors.transparent,
      backgroundColor?.withOpacity(0.0) ?? Colors.transparent,
    ];

    if (!rtl) {
      colors = colors.reversed.toList();
    }

    return Positioned(
      left: rtl ? 0 : null,
      right: !rtl ? 0 : null,
      top: 0,
      bottom: 0,
      child: Container(
        width: 16.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
        ),
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
