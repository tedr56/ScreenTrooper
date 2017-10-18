#ifndef FOLDERIO_H
#define FOLDERIO_H

#include <QObject>
#include <QMap>

class FolderIO : public QObject
{
    Q_OBJECT
public:
    explicit FolderIO(QObject *parent = nullptr);

    Q_INVOKABLE QString getFile(QString Directory, int last_added = 0);
signals:

public slots:

private:
    int m_file_counter = -1;
    int m_file_index = -1;

    QMap<QString, int> m_directory;
    QMap<QString, int> m_lastplayed;

};

#endif // FOLDERIO_H
