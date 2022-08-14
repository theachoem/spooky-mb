part of add_ons_view;

class _AddOnsMobile extends StatelessWidget {
  final AddOnsViewModel viewModel;
  const _AddOnsMobile(this.viewModel);

  double get expandedHeight => 200;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InAppPurchaseProvider>(context);
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: SpSingleButtonBottomNavigation(
        buttonLabel: tr("button.restore_purchase"),
        show: provider.restorable,
        onTap: () async {
          if (provider.currentUser == null) {
            openLoginDialog(context);
            return;
          }

          MessengerService.instance.showLoading(
            future: () => provider.loadPurchasedProducts().then((value) => 1),
            context: context,
            debugSource: '_AddOnsMobile#build - Restore Purchase',
          );

          provider.restore();
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchProducts(),
        displacement: expandedHeight / 2,
        child: CustomScrollView(
          slivers: [
            buildAppBar(),
            buildBody(provider),
          ],
        ),
      ),
    );
  }

  SpExpandedAppBar buildAppBar() {
    return SpExpandedAppBar(
      expandedHeight: expandedHeight,
      fallbackRouter: SpRouter.addOn,
      actions: [
        Container(
          transform: Matrix4.identity()..translate(4.0, 0.0),
          child: UserIconButton(),
        ),
      ],
    );
  }

  SliverPadding buildBody(InAppPurchaseProvider provider) {
    return SliverPadding(
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
    );
  }

  Widget buildWholeCard({
    required int index,
    required InAppPurchaseProvider provider,
    required List<PurchaseDetails> purchaseDetails,
    required BuildContext context,
  }) {
    // local product
    ProductModel product = viewModel.productList.products[index];

    // hosted product
    Iterable<ProductDetails> result = provider.productDetails.where((e) => e.id == product.type.productId);
    ProductDetails? productDetails = result.isNotEmpty ? result.first : null;

    return buildFadeInWrapper(
      index: index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProductTile(
            leadingIconData: product.icon,
            context: context,
            index: index,
            title: product.title,
            subtitle: productDetails?.description ?? product.description,
            price: productDetails?.price,
            type: product.type,
            onBuyPressed: () async {
              if (provider.currentUser?.uid == null) {
                openLoginDialog(context);
                return;
              }
              if (productDetails != null) {
                provider.buyProduct(productDetails);
              } else {
                MessengerService.instance.showSnackBar(tr("msg.add_on_unavailable"));
              }
            },
            onTryPressed: () {
              product.onTryPressed();
            },
          ),
          ValueListenableBuilder<Map<String, List<MessageModel>>>(
            valueListenable: provider.messageNotifier,
            builder: (context, value, child) {
              List<MessageModel>? messages = value[product.type.productId];
              return SpCrossFade(
                showFirst: messages?.where((e) => e.message != null).isNotEmpty == true,
                secondChild: const SizedBox(width: double.infinity),
                firstChild: Container(
                  margin: const EdgeInsets.only(bottom: ConfigConstant.margin2),
                  child: buildMessages(messages, context),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> openLoginDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: tr("alert.login_required.title"),
      message: tr("alert.login_required.message"),
      okLabel: tr("button.login"),
    );
    if (result == OkCancelResult.ok) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushNamed(SpRouter.signUp.path);
    }
  }

  Widget buildMessages(List<MessageModel>? messages, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        messages?.length ?? 0,
        (index) {
          MessageModel message = messages![index];
          return AnimatedOpacity(
            opacity: message.message != null ? 1 : 0,
            duration: ConfigConstant.fadeDuration,
            child: SpCrossFade(
              duration: ConfigConstant.duration * 1.5,
              firstChild: Container(
                margin: EdgeInsets.only(bottom: index != messages.length - 1 ? ConfigConstant.margin0 : 0),
                child: buildMessage(
                  context: context,
                  message: message.message ?? "",
                  error: message.isError,
                ),
              ),
              secondChild: const SizedBox(width: double.infinity),
              showFirst: message.message != null,
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

  Widget buildMessage({
    required BuildContext context,
    required String message,
    bool error = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: kToolbarHeight - 8, bottom: ConfigConstant.margin0),
      padding: const EdgeInsets.all(ConfigConstant.margin2),
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
    required ProductAsType type,
  }) {
    Color? backgroundColor = M3Color.dayColorsOf(context)[index % 6 + 1];
    Color foregroundColor = M3Color.of(context).background;
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
            child: Consumer<InAppPurchaseProvider>(builder: (context, provider, child) {
              bool purchased = provider.purchased(type);
              return SpPopupMenuButton(
                dyGetter: (dy) => dy + kToolbarHeight,
                dxGetter: (dx) => dx - 8.0,
                items: (context) {
                  return [
                    SpPopMenuItem(
                      title: tr("button.buy"),
                      leadingIconData: Icons.payment,
                      onPressed: onBuyPressed,
                      titleStyle: TextStyle(color: backgroundColor),
                    ),
                    SpPopMenuItem(
                      title: tr("button.try"),
                      leadingIconData: Icons.play_arrow,
                      onPressed: onTryPressed,
                    ),
                  ];
                },
                builder: (callback) {
                  return SpTapEffect(
                    onTap: () {
                      if (!purchased) {
                        callback();
                      } else {
                        onTryPressed();
                      }
                    },
                    effects: const [SpTapEffectType.scaleDown],
                    child: Stack(
                      children: [
                        buildWaves(
                          circlarRadius: circlarRadius,
                          backgroundColor: backgroundColor,
                          foregroundColor: foregroundColor,
                          context: context,
                        ),
                        buildProductInfo(
                          circlarRadius: circlarRadius,
                          title: title,
                          type: type,
                          subtitle: subtitle,
                          foregroundColor: foregroundColor,
                          context: context,
                          backgroundColor: backgroundColor,
                          price: price,
                        ),
                        Positioned(
                          right: ConfigConstant.margin2,
                          bottom: ConfigConstant.margin2,
                          child: SpAddOnVisibility(
                            type: type,
                            child: RichText(
                              text: TextSpan(
                                text: "${tr("msg.purchased")} ",
                                style: M3TextTheme.of(context).labelSmall?.copyWith(color: backgroundColor),
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.check,
                                      color: backgroundColor,
                                      size: ConfigConstant.iconSize1,
                                    ),
                                    alignment: PlaceholderAlignment.middle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
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
    required ProductAsType type,
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
                  style: TextStyle(color: foregroundColor.withOpacity(0.75)),
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
          SpAddOnVisibility(
            type: type,
            reverse: true,
            child: Icon(
              Icons.more_vert,
              color: backgroundColor,
            ),
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

  Widget buildFadeInWrapper({required Widget child, int? index}) {
    return FutureBuilder(
      future: Future.delayed(ConfigConstant.duration * (index ?? 0 + 1)).then((value) => 1),
      builder: (context, snapshot) {
        return AnimatedContainer(
          duration: ConfigConstant.duration,
          transform: Matrix4.identity()..translate(0.0, snapshot.data == 1 ? 0.0 : 8.0),
          child: AnimatedOpacity(
            duration: ConfigConstant.fadeDuration,
            opacity: snapshot.data == 1 ? 1.0 : 0.0,
            child: child,
          ),
        );
      },
    );
  }

  Widget buildWaves({
    required BorderRadius circlarRadius,
    required Color? backgroundColor,
    required Color foregroundColor,
    required BuildContext context,
  }) {
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
          size: const Size(
            double.infinity,
            double.infinity,
          ),
        ),
      ),
    );
  }
}
