import 'package:drift_bottle/dto/account.dart';

class TypeConvert{

   static List listConvert(list,obj){

     if(obj is Account){

       List result = new List<Account>();
       for(dynamic d in list){
         result.add(Account.fromJson(d));
       }
       return result;
     }
     return null;
  }

}