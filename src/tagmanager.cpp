#include "tagmanager.h"
#include <QDebug>


TagManager::TagManager(QObject *parent) :
    QObject(parent)
{
}

void TagManager::sortAndSaveTags(QVariantList names, QVariantList counts)
{
    for (int i = 0; i < names.size(); ++i)
    {
        mSortedTags.insert(names.at(i).toString().toLower(), counts.at(i).toInt());
    }
    qDebug() << "got" << mSortedTags.size() << "sorted tags";
    emit tagsAvailable();
}

QVariantList TagManager::getTags()
{
    QVariantList variantlist;
    foreach(QString key, mSortedTags.keys())
    {
        variantlist << key;
    }
    return variantlist;
}

QVariantList TagManager::getTagAmounts()
{
    QVariantList variantlist;
    foreach(int value, mSortedTags.values())
    {
        variantlist << value;
    }
    return variantlist;
}
