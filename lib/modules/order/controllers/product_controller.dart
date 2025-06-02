import 'package:get/get.dart';
import 'package:home_delivery_br/data/models/ProductModel.dart';
import 'package:home_delivery_br/modules/order/controllers/ProductFormModel.dart';

class ProductController extends GetxController {
  final RxList<ProductFormModel> products = <ProductFormModel>[].obs;

  void addProduct() {
    final newProduct = ProductFormModel();
    products.add(newProduct);
    products.refresh();
  }

  void removeProduct(int index) {
    if (index >= 0 && index < products.length) {
      products[index].dispose();
      products.removeAt(index);
      products.refresh();
    }
  }

  void clear() {
    for (var product in products) {
      product.dispose();
    }
    products.clear();
  }

  List<Map<String, dynamic>> toJson() {
    return products.map((p) => p.toProduct().toJson()).toList();
  }

  @override
  void onClose() {
    clear();
    super.onClose();
  }

  void loadProductsFromOrder(List<Product> orderProducts) {
    clear();
    for (var p in orderProducts) {
      final product = ProductFormModel();

      product.selectedShCode.value = p.shCode;
      product.descriptionController.text = p.description?.toString() ?? '';
      product.quantityController.text = p.quantity?.toString() ?? '';
      product.valueController.text = p.value?.toString() ?? '';
      product.isBattery.value = p.isBattery == 1;
      product.isPerfume.value = p.isPerfume == 1;
      product.isFlameable.value = p.isFlameable == 1;
      products.add(product);
    }
    products.refresh();
  }
}
