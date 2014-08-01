#include "ambiencemanager.h"
#include <QStandardPaths>
#include <QDebug>
#include <QImage>
#include <QFileInfo>
#include <QDir>

AmbienceManager::AmbienceManager(QObject *parent) :
    QObject(parent), mThumbnailReply(0), mFullImageReply(0)
{
    mPictureLocation = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
    mCacheLocation = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
    QDir root(QDir::rootPath());
    if (!root.mkpath(mCacheLocation))
    {
        qDebug() << "failed to create cachedir";
    }
}

QString AmbienceManager::thumbnail(QString name)
{
    return mCacheLocation + "/" + name;
}

bool AmbienceManager::hasThumbnail(QString name)
{
    QString filePath = mCacheLocation + "/" + name;
    return (QFile::exists(filePath));
}

void AmbienceManager::saveImageToGallery(QString name)
{
    if (QFile::exists(mCacheLocation + "/" + "ambience-" + name))
    {
        QFile::copy(mCacheLocation + "/" + "ambience-" + name, mPictureLocation + "/" + "ambience-" + name);
        emit saveImageToGallerySucceeded();
    }
    else
    {
        qDebug() << name << "does not exist, cannot copy to gallery";
    }
}

void AmbienceManager::saveThumbnail(QUrl fileUrl, QString name)
{
    mThumbnailQueue.enqueue(qMakePair(fileUrl, name));
    if (!mThumbnailReply) // if no ongoing thumbnail download
    {
       saveNextThumbnail();
    }
}

void AmbienceManager::saveNextThumbnail()
{

    QPair<QUrl, QString> thumbnail = mThumbnailQueue.dequeue();
    QNetworkRequest request;
    request.setUrl(QUrl(thumbnail.first));
    mThumbnailReply = mNam.get(request);
    connect(mThumbnailReply, &QNetworkReply::finished,
            this, &AmbienceManager::onSaveThumbnailFinished);

    mThumbnail = new QFile;
    mThumbnail->setFileName(mCacheLocation + "/" + thumbnail.second);
    mThumbnail->open(QIODevice::WriteOnly);
}

void AmbienceManager::onSaveThumbnailFinished()
{
    disconnect(mThumbnailReply, &QNetworkReply::finished,
            this, &AmbienceManager::onSaveThumbnailFinished);
    if (!mThumbnailReply->error())
    {
        qDebug() << "no error, saving file";
        QImage* fullSizeImage = new QImage;
        fullSizeImage->loadFromData(mThumbnailReply->readAll());
        QImage thumbnailImage(fullSizeImage->scaled(QSize(250, 740)));
        delete fullSizeImage;
        thumbnailImage.save(mThumbnail);
        qDebug() << "saved: " << mThumbnail->fileName();
        mThumbnail->close();
        QFileInfo info(mThumbnail->fileName());
        delete mThumbnail;
        mThumbnail = 0;
        emit saveThumbnailSucceeded(info.fileName());
    }
    mThumbnailReply->deleteLater();
    mThumbnailReply = 0;

    if (!mThumbnailQueue.isEmpty())
    {
        saveNextThumbnail();
    }
}

void AmbienceManager::saveFullImage(QUrl fileUrl, QString name)
{
    QNetworkRequest request;
    request.setUrl(QUrl(fileUrl));
    mFullImageReply = mNam.get(request);
    connect(mFullImageReply, &QNetworkReply::finished,
            this, &AmbienceManager::onSaveFullImageFinished);

    mFullImage = new QFile;
    mFullImage->setFileName(mCacheLocation + "/" + "ambience-" + name);
    mFullImage->open(QIODevice::WriteOnly);
}

void AmbienceManager::onSaveFullImageFinished()
{
    disconnect(mFullImageReply, &QNetworkReply::finished,
            this, &AmbienceManager::onSaveFullImageFinished);
    if (!mFullImageReply->error())
    {
        qDebug() << "no error, saving file";
        mFullImage->write(mFullImageReply->readAll());
        mFullImage->close();
        emit saveFullImageSucceeded(mFullImage->fileName());
    }
    mFullImageReply->deleteLater();
    mFullImageReply = 0;
}






