#include "fileio.h"
#include <QFile>
#include <QTextStream>
#include <QUrl>
#include <QDir>
#include <QDebug>

FileIO::FileIO(QObject *parent) :
    QObject(parent)
{
    mWatcher = new QFileSystemWatcher(this);
    connect(mWatcher, SIGNAL(fileChanged(QString)), this, SLOT(DataChanged(QString)));
}

QString FileIO::read()
{

    if (mSource.isEmpty()){
        emit error("source is empty");
        return QString();
    }


    QFile file(QUrl(mSource).toLocalFile());
    if (!file.exists()) {
        emit error("File doesn't exist");
        return QString();
    }

    QString fileContent;
    if ( file.open(QIODevice::ReadOnly) ) {
        QString line;
        QTextStream t( &file );
        do {
            line = t.readLine();
            fileContent += line;
         } while (!line.isNull());

        file.close();
    } else {
        emit error("Unable to open the file");
        return QString();
    }
    return fileContent;
}

bool FileIO::write(const QString& data)
{
    if (mSource.isEmpty()) {
        return false;
    }

    QFile file(QUrl(mSource).toLocalFile());
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
        return false;

    QTextStream out(&file);
    out << data;

    file.close();

    return true;
}

QString FileIO::source()
{
    return mSource;
}

bool FileIO::exists(const QString &source)
{
    return QFile(QUrl(source).toLocalFile()).exists();
}

QString FileIO::getFile(const int fileIndex, const QString Directory)
{
    QDir folder(QUrl(Directory).toLocalFile());
    QStringList files(folder.entryList(QDir::Files));
    if (fileIndex >= 0 && fileIndex < files.size()) {
        return files[fileIndex];
    }
    return "";
}

void FileIO::setSource(const QString &source)
{
    if (!source.isEmpty() && exists(source)) {
        mWatcher->removePath(QUrl(source).toLocalFile());
        mSource = source;
        addWatcher();
        emit dataChanged();
    }
}

void FileIO::DataChanged(QString)
{
    emit dataChanged();
    addWatcher();
}

bool FileIO::addWatcher()
{
    return mWatcher->addPath(QUrl(mSource).toLocalFile());
}
