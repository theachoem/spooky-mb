part of add_ons_view;

class _AddOnsMobile extends StatelessWidget {
  final AddOnsViewModel viewModel;
  const _AddOnsMobile(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MorphingAppBar(title: SpAppBarTitle()),
      body: Consumer<GooglePayProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchProducts(),
            child: buildListView(provider),
          );
        },
      ),
    );
  }

  Widget buildListView(GooglePayProvider provider) {
    return ListView.builder(
      itemCount: provider.productDetails.length,
      itemBuilder: (context, index) {
        ProductDetails item = provider.productDetails[index];
        return ValueListenableBuilder<List<PurchaseDetails>>(
          valueListenable: provider.purchaseNotifier,
          builder: (context, purchaseDetails, child) {
            Iterable<PurchaseDetails> _purchaseDetails = purchaseDetails.where((e) => e.productID == item.id);
            PurchaseDetails? streamDetails = _purchaseDetails.isNotEmpty ? _purchaseDetails.first : null;
            IAPError? error = streamDetails?.error;
            return ExpansionTile(
              title: Text(item.title),
              subtitle: Text(item.description),
              trailing: Text(streamDetails?.status.name.capitalize ?? item.price),
              children: [
                ListTile(
                  title: Text(item.toString()),
                  subtitle: Text(
                    AppHelper.prettifyJson({
                      "id": item.id,
                      "title": item.title,
                      "description": item.description,
                      "price": item.price,
                      "rawPrice": item.rawPrice,
                      "currencyCode": item.currencyCode,
                      "currencySymbol": item.currencySymbol,
                    }),
                    maxLines: null,
                  ),
                ),
                if (error != null)
                  ListTile(
                    title: Text("Error"),
                    subtitle: Text(
                      error.toString().replaceAll(", ", "\n").replaceFirst("IAPError(", "").replaceAll(")", ""),
                      maxLines: null,
                    ),
                  ),
                SpButton(
                  label: "Buy",
                  onTap: () {
                    provider.buyProduct(item);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
