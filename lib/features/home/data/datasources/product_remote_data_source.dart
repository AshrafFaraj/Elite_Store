import '../../../../core/services/api_service.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<ProductModel> getProductDetails(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await apiService.get('/products');
    return (response as List).map((item) => ProductModel.fromJson(item)).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await apiService.get('/products/category/$category');
    return (response as List).map((item) => ProductModel.fromJson(item)).toList();
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final response = await apiService.get('/products/$id');
    return ProductModel.fromJson(response);
  }
}
