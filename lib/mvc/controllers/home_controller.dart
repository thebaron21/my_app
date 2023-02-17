import 'package:get/get.dart';
import 'package:my_app/custom/get_route.dart';

import '../views/home/history_complaints.dart';
import '../views/home/new_complaints.dart';
import '../views/home/regulations_screen.dart';

class HomeController{



  newComplaint(context){
    CRoute.of(context).push(() => const NewComplaintScreen());
  }

  historyComplaint(context){
    CRoute.of(context).push(() => const HistoryComplaintsScreen());
  }

  regulations(context){
    CRoute.of(context).push(() => const RegulationsScreen());
  }


}