#include "folderio.h"
#include <QDir>

FolderIO::FolderIO(QObject *parent) : QObject(parent)
{
}

QString FolderIO::getFile(QString Directory, int last_added)
{
    if (Directory.isEmpty())
        return "";

    if (!Directory.compare(m_directory)) {
        m_directory = Directory;
    }

    QDir *folder = new QDir(m_directory);
    folder->setFilter(QDir::Files);
    folder->setSorting(QDir::Time);

    if (m_file_counter < 0)
        m_file_counter = folder->count() - last_added;

    if (m_file_counter < 0)
        m_file_counter = 0;


    QString result = folder->entryList()[m_file_counter];

    m_file_counter++;

    if (m_file_counter == folder->count() - 1) {
        m_file_counter = folder->count() - last_added;
    }
    return result

}
