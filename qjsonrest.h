#ifndef QJSONREST_H
#define QJSONREST_H


#include <QObject>
#include "QSimpleRestServer/src/restserver.h"
#include "QSimpleRestServer/src/restrequestlistener.h"
#include "QSimpleRestServer/src/restrequest.h"

class QJsonRest : public RESTRequestListener
{
    Q_OBJECT
    public:
      explicit QJsonRest(QObject * parent = 0);

    signals:
        void dataChanged(QString path, QString value);
        void dataRequested();

    public slots:
      void http_get_STAR( RESTRequest * request );
      void http_get_footer_enable( RESTRequest * request );

};

#endif // QJSONREST_H
