/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Marko Mattila <marko.mattila@jollamobile.com>
** All rights reserved.
**
** This file is part of Nemo Transfer Engine package.
**
** You may use this file under the terms of the GNU Lesser General
** Public License version 2.1 as published by the Free Software Foundation
** and appearing in the file license.lgpl included in the packaging
** of this file.
**
** This library is free software; you can redistribute it and/or
** modify it under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation
** and appearing in the file license.lgpl included in the packaging
** of this file.
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** Lesser General Public License for more details.
**
****************************************************************************************/

#ifndef DBMANAGER_H
#define DBMANAGER_H
#include <QObject>

#include "transferdbrecord.h"
#include "mediatransferinterface.h"

class MediaItem;
class DbManagerPrivate;
class DbManager
{
public:
    static DbManager *instance();

    ~DbManager();

    int createMetadataEntry(int key, const QString &title, const QString &description);

    QStringList callback(int key) const;

    int createCallbackEntry(int key,
                            const QString &service,
                            const QString &path,
                            const QString &interface,
                            const QString &cancelMethod,
                            const QString &restartMethod);

    int createTransferEntry(MediaItem *mediaItem);

    bool updateTransferStatus(int key, TransferEngineData::TransferStatus status);

    bool updateProgress(int key, qreal progress);

    bool removeTransfer(int key);

    bool clearFailedTransfers(int excludeKey, TransferEngineData::TransferType type);

    bool clearTransfers();

    QList<TransferDBRecord> transfers() const;

    TransferEngineData::TransferType transferType(int key) const;

    TransferEngineData::TransferStatus transferStatus(int key) const;

    bool callbackMethods(int key, QString &cancelMethod, QString &restartMethod) const;

    MediaItem * mediaItem(int key) const;

private:
    DbManager();
    DbManagerPrivate *d_ptr;
    Q_DECLARE_PRIVATE(DbManager)
};

#endif // DBMANAGER_H
