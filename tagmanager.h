#ifndef TAGMANAGER_H
#define TAGMANAGER_H

#include <QObject>
#include <QMap>
#include <QVariantList>

class TagManager : public QObject
{
    Q_OBJECT

public:
    explicit TagManager(QObject *parent = 0);
    Q_INVOKABLE void sortAndSaveTags(QVariantList names, QVariantList counts);
    Q_INVOKABLE QVariantList getTags();
    Q_INVOKABLE QVariantList getTagAmounts();

public slots:

signals:
    void tagsAvailable();

private:
    QMap<QString, int> mSortedTags;

};

#endif // TAGMANAGER_H
