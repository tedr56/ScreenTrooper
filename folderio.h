#ifndef FOLDERIO_H
#define FOLDERIO_H

#include <QObject>

class FolderIO : public QObject
{
    Q_OBJECT
public:
    explicit FolderIO(QObject *parent = nullptr);

    Q_INVOKABLE QString getFile(QString Directory, int last_added);
signals:

public slots:

private:
    int m_file_counter = -1;
    int m_file_index = -1;
    QString m_directory = "";

};

#endif // FOLDERIO_H
