import 'package:get/get.dart';
import '../../../network/api_manager.dart';
import '../../../network/api_end_point.dart';

import '../model/list_of_product_model.dart';
import '../../../network/api_end_point.dart';

class HomeViewModel extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ListOfProduct> product = RxList<ListOfProduct>([]);

  void getAllProduct() async {
      this.isLoading.value = true;

      final APIEndpoint endpoint = APIEndpoint(
          path: 'https://fakestoreapi.com/products',
        method: HTTPMethod.GET
      );

      final result = await APIManager.instance.request<List<ListOfProduct>>(
        endpoint,
            (data) => listOfProductFromJson(data),
      );


      isLoading.value = false;

      if (result.data != null ) {
        print(result.data!.length);
      }
      }


  }




