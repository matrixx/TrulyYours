/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 matrixx
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

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
    Q_INVOKABLE QString thumbnail(QString name);
    Q_INVOKABLE bool hasThumbnail(QString name);
    Q_INVOKABLE bool saveImageToGallery(QString name);
    Q_INVOKABLE bool saveImageToGalleryAndApplyAmbience(const QString &name);

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
    ComJollaAmbiencedInterface *mInterface;
};

#endif // AMBIENCEMANAGER_H
