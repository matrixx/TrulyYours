#ifndef AMBIENCEMANAGER_H
#define AMBIENCEMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>
#include <QQueue>
#include <QStringList>
#include "ambienced.h"

class AmbienceManager : public QObject
{
    Q_OBJECT
public:
    explicit AmbienceManager(QObject *parent = 0);
    virtual ~AmbienceManager();
    Q_INVOKABLE QString thumbnail(const QString &name);
    Q_INVOKABLE bool hasThumbnail(const QString &name);
    Q_INVOKABLE bool saveImageToGallery(const QString &name);
    Q_INVOKABLE bool saveImageToGalleryAndApplyAmbience(const QString &name);

signals:
    void saveImageToGallerySucceeded();
    void saveThumbnailSucceeded(const QString &name);
    void saveFullImageSucceeded(const QString &name);

public slots:
    void saveThumbnail(const QUrl &fileUrl, const QString &name);
    void onSaveThumbnailFinished();
    void saveFullImage(const QUrl &fileUrl, const QString &name);
    void onSaveFullImageFinished();

private: // methods
    void saveNextThumbnail();

private: // data
    QNetworkAccessManager mNam;
    QNetworkReply* mThumbnailReply;
    QNetworkReply* mFullImageReply;
    QFile* mThumbnail;
    QFile* mFullImage;
    QString mPictureLocation;
    QString mCacheLocation;
    QQueue<QPair<QUrl, QString> > mThumbnailQueue;
    QStringList mSavedFullImages;
    ComJollaAmbiencedInterface *mInterface;
};

#endif // AMBIENCEMANAGER_H
