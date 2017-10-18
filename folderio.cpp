#include "folderio.h"
#include <QDir>
#include <QUrl>

FolderIO::FolderIO(QObject *parent) : QObject(parent)
{
}

QString FolderIO::getFile(QString Directory, int last_added)
{
    if (Directory.isEmpty())    return "";

    if (!m_lastplayed.contains(Directory)) {
        m_lastplayed.insert(Directory, 0);
    }

    QDir *folder = new QDir(QUrl(Directory).toLocalFile());
    folder->setFilter(QDir::Files);
    if (last_added > 0) {
        folder->setSorting(QDir::Time);
    } else {
        folder->setSorting(QDir::Name);
    }
    if (m_lastplayed[Directory] >= folder->count()) {
        if (last_added > 0) {
            m_lastplayed[Directory] = folder->count() - last_added;
            if (m_lastplayed[Directory] < 0) {
                m_lastplayed[Directory] = 0;
            }
            return "";
        } else {
            m_lastplayed[Directory] = 0;
            return "";
        }
    }

    QString result = folder->entryList()[m_lastplayed[Directory]];

    m_lastplayed[Directory] = m_lastplayed[Directory] + 1;

    return result;
}
