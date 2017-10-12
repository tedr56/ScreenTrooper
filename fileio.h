#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFileSystemWatcher>
#include <QTimer>

class FileIO : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString source
               READ source
               WRITE setSource
               NOTIFY sourceChanged)

    explicit FileIO(QObject *parent = 0);

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString& data);

    QString source() ;

    Q_INVOKABLE bool exists(const QString& source);

    Q_INVOKABLE QString getFile(const int fileIndex, const QString Directory);

public slots:
    void setSource(const QString& source);
    void DataChanged(QString);

signals:
    void sourceChanged(const QString& source);
    void error(const QString& msg);
    void dataChanged();

private:
    QString mSource;
    QFileSystemWatcher* mWatcher;
    bool addWatcher();
};

#endif // FILEIO_H
