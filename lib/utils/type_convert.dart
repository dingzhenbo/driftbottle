import 'package:drift_bottle/dto/account.dart';
import 'package:drift_bottle/dto/conversation.dart';
import 'package:drift_bottle/dto/message.dart';

class TypeConvert{

   static List listConvert(list,obj){

     if(obj is Account){

       List result = new List<Account>();
       for(dynamic d in list){
         result.add(Account.fromJson(d));
       }
       return result;
     }else if(obj is Conversation){
       List result = new List<Conversation>();
       for(dynamic d in list){
         result.add(Conversation.fromJson(d));
       }
       return result;
     }else if(obj is Message){
       List result = new List<Message>();
       for(dynamic d in list){
         result.add(Message.fromjson(d));
       }
       return result;
     }
     return null;
  }

}