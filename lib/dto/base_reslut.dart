class BaseResult{
  final String result;  //返回结果 ok // not_ok
  final Map data;   //返回数据
  final String success; //操作成功。保存操作成功提示信息
  final String error; //操作失败提示信息

  BaseResult({this.result,this.data,this.success,this.error});

  factory BaseResult.fromJson(Map<String, dynamic> json) {
    return BaseResult(
      result: json['result'],
      data: json['data'],
      success: json['success'],
      error: json['error'],
    );
  }
}