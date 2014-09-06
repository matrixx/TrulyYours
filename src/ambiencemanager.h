#ifndef AMBIENCEMANAGER_H
#define AMBIENCEMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFile>
#include <QQueue>
#include <QStringList>

class AmbienceManager : public QObject
{
    Q_OBJECT
public:
    explicit AmbienceManager(QObject *parent = 0);
    virtual ~AmbienceManager();
    Q_INVOKABLE QString thumbnail(QString name);
    Q_INVOKABLE bool hasThumbnail(QString name);
    Q_INVOKABLE void saveImageToGallery(QString name);

signals:
    void saveImageToGallerySucceeded();
    void saveThumbnailSucceeded(QString);
    void saveFullImageSucceeded(QString);

public slots:
    Q_INVOKABLE void saveThumbnail(QUrl fileUrl, QString name);
    void onSaveThumbnailFinished();
    Q_INVOKABLE void saveFullImage(QUrl fileUrl, QString name);
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
};

#endif // AMBIENCEMANAGER_H
