
class CacheFile{

  int id=-1;
  String url="";
  String localName="";

  CacheFile(id, this.url, this.localName);

  CacheFile.empty();

  CacheFile.fromMap(Map<String, dynamic> item) {
    id=item["id"];
    url=item["url"];
    localName=item["localName"];
  }

  Map<String, Object> toMap(){
    return {'id': id, 'url': url, 'localName': localName};
  }

  bool isEmpty() => id==-1;


}