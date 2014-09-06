#include "ambiencemanager.h"
#include <QStandardPaths>
#include <QDebug>
#include <QImage>
#include <QFileInfo>
#include <QDir>
#include <QVariant>

static const char *AMBIENCED_SERVICE = "com.jolla.ambienced";
static const char *AMBIENCED_PATH = "/com/jolla/ambienced";

AmbienceManager::AmbienceManager(QObject *parent) :
    QObject(parent),
    mThumbnailReply(0),
    mFullImageReply(0),
    mThumbnail(0),
    mFullImage(0),
    mInterface(0)
{
    mPictureLocation = QStandardPaths::writableLocation(QStandardPaths::PicturesLocation);
    mCacheLocation = QStandardPaths::writableLocation(QStandardPaths::DataLocation);
    QDir root(QDir::rootPath());
    if (!root.mkpath(mCacheLocation))
    {
        qDebug() << "failed to create cachedir";
    }

    mInterface = new ComJollaAmbiencedInterface(AMBIENCED_SERVICE, AMBIENCED_PATH, QDBusConnection::sessionBus(), this);
}

AmbienceManager::~AmbienceManager()
{
    if (mThumbnail)
    {
        mThumbnail->close();

        // if client was shut down during thumbnail download
        if (mThumbnail->size() == 0)
        {
            // remove empty file
            mThumbnail->remove();
        }
        delete mThumbnail;
        mThumbnail = 0;
    }

    if (mFullImage)
    {
        mFullImage->close();

        // if client was shut down during full image download
        if (mFullImage->size() == 0)
        {
            // remove empty file
            mFullImage->remove();
        }
        delete mFullImage;
        mFullImage = 0;
    }

    // delete cached full size images
    foreach (QString fileName, mSavedFullImages)
    {
        QFile::remove(fileName);
    }
}

QString AmbienceManager::thumbnail(const QString &name)
{
    return mCacheLocation + "/" + name;
}

bool AmbienceManager::hasThumbnail(const QString &name)
{
    QString filePath = mCacheLocation + "/" + name;
    return (QFile::exists(filePath));
}

static inline QString createAmbienceImage(const QString &pictureLocation, const QString &name)
{
    return pictureLocation + "/ambience-" + name;
}

bool AmbienceManager::saveImageToGallery(const QString &name)
{
    if (!QFile::exists(mCacheLocation + "/ambience-" + name))
    {
        qDebug() << name << "does not exist, cannot copy to gallery";
        return false;
    }

    QFile::copy(mCacheLocation + "/ambience-" + name, createAmbienceImage(mPictureLocation, name));
    mSavedFullImages.append(mCacheLocation + "/ambience-" + name);
    emit saveImageToGallerySucceeded();
    return true;
}

bool AmbienceManager::saveImageToGalleryAndApplyAmbience(const QString &name)
{
    if (!saveImageToGallery(name)) {
        return false;
    }

    QString url = QUrl::fromLocalFile(createAmbienceImage(mPictureLocation, name)).toString();
    mInterface->createAmbience(url);
    mInterface->setAmbience(url);
    return true;
}

void AmbienceManager::saveThumbnail(const QUrl &fileUrl, const QString &name)
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
    if (!mThumbnailReply->error()) // TODO: handle error case
    {
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

void AmbienceManager::saveFullImage(const QUrl &fileUrl, const QString &name)
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
    if (!mFullImageReply->error()) // TODO: handle error case
    {
        qDebug() << "no error, saving file";
        mFullImage->write(mFullImageReply->readAll());
        mFullImage->close();
        emit saveFullImageSucceeded(mFullImage->fileName());
        delete mFullImage;
        mFullImage = 0;
    }
    mFullImageReply->deleteLater();
    mFullImageReply = 0;
}






