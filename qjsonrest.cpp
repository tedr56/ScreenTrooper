#include "qjsonrest.h"

QJsonRest::QJsonRest(QObject *parent) : RESTRequestListener("/", parent)
{

}

void QJsonRest::http_get_STAR(RESTRequest * request)
{
  request->result()->setData( "http_get" );
  request->result()->setStatusCode( 200 );
  request->result()->setData(request->path());
  emit dataChanged("test", "testy");
  emit dataRequested();
}

void QJsonRest::http_get_footer_enable(RESTRequest *request)
{
    request->result()->setData( "Hello World" );
    request->result()->setStatusCode( 200 );
    emit dataChanged("/footer/enable", "testy");
    emit dataRequested();
}
