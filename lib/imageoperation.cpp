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

#include "imageoperation.h"
#include <quillmetadata/QuillMetadata>

#include <QFileInfo>
#include <QtDebug>
#include <QImage>
#include <QSize>

/*!
    \class ImageOperation
    \brief The ImageOperation class is a helper class to manipulate images.

    This class is meant to be used by share plugins. It can be used for:
    \list
        \o Removing image metadata
        \o Scaling image
        \o Create a temp files from the image paths
    \endlist
*/

/*!
    Creates a file path from the \a sourceFilePath to the \a path location.
    If the path is not given it uses system default temp path e.g. '/var/tmp'.
    This function uses sourceFilePath as a template to generate a temp file name.

    NOTE: This function doesn't create the file, it only generates the file path to
    the temporary file.

    Temporary file will be e.g:

    Source file: "/home/nemo/Pictures/img_001.jpg"
    Temporary file: "/var/tmp/img_001_0.jpg"
 */
QString ImageOperation::uniqueFilePath(const QString &sourceFilePath, const QString &path)
{
    if (sourceFilePath.isEmpty() || !QFile::exists(sourceFilePath)) {
        qWarning() << Q_FUNC_INFO << sourceFilePath << "Doesn't exist or then the path is empty!";
        return QString();
    }

    if (path.isEmpty()) {
        qWarning() << Q_FUNC_INFO << "'path' argument is empty!";
        return QString();
    }

    QFileInfo fileInfo(sourceFilePath);


    // Construct target temp file path first:
    QDir dir(path);
    QStringList prevFiles = dir.entryList(QStringList() << fileInfo.baseName() + QLatin1String("*"), QDir::Files);
    int count = prevFiles.count();

    // Create temp file with increasing index in a file name e.g.
    // /var/temp/img_001_0.jpg, /var/temp/img_001_1.jpg
    // In a case there already is a file with the same filename
    QString filePath = dir.absolutePath() + QDir::separator();
    QString fileName =  fileInfo.baseName() +
                        QLatin1String("_") +
                        QString::number(count) +
                        QLatin1String(".") +
                        fileInfo.suffix();

    // This makes sure that we don't generate a file name which already exists. E.g. there are files:
    // img_001_0, img_001_1, img_001_2 and img_001 gets deleted. Then this code would generate a
    // filename img_001_2 which already exists
    while(prevFiles.contains(fileName)) {
        ++count;
        fileName =  fileInfo.baseName() +
                    QLatin1String("_") +
                    QString::number(count) +
                    QLatin1String(".") +
                    fileInfo.suffix();
    }

    return filePath + fileName;
}

/*!
   Helper method to remove metadata from jpeg files. Only author and location related
   metadata will be removed. \a sourceFile is the path to the original file.

   Returns a path to the copy of the image with metadata removed.
 */
QString ImageOperation::removeImageMetadata(const QString &sourceFile)
{

    if (!QuillMetadata::canRead(sourceFile)) {
        qWarning() << Q_FUNC_INFO << "Can't read the source: " << sourceFile;
        return QString();
    }

    QString targetFile = uniqueFilePath(sourceFile);

    // Copy image content first
    if (!QFile::copy(sourceFile, targetFile)) {
        qWarning() << Q_FUNC_INFO << "Failed to copy content!";
        return QString();
    }

    // Get metadata and remove it
    QuillMetadata md(sourceFile);
    if(!md.isValid()) {
        qWarning() << Q_FUNC_INFO << "Invalid metadata";
        return QString();
    }

    // Remove bunch of metadata entries
    md.removeEntry(QuillMetadata::Tag_Creator);
    md.removeEntry(QuillMetadata::Tag_Subject);
    md.removeEntry(QuillMetadata::Tag_Title);
    md.removeEntry(QuillMetadata::Tag_City);
    md.removeEntry(QuillMetadata::Tag_Country);
    md.removeEntry(QuillMetadata::Tag_Location);
    md.removeEntry(QuillMetadata::Tag_Description);
    md.removeEntry(QuillMetadata::Tag_Regions);
    md.removeEntry(QuillMetadata::Tag_Timestamp);
    md.removeEntries(QuillMetadata::TagGroup_GPS);

    // Write modified metadata to the target file
    if (!md.write(targetFile)) {
        qWarning() << Q_FUNC_INFO << "Failed to clear metadata!";
        return QString();
    }
    // Return new file with removed metadata
    return targetFile;
}

/*!
    Scale image \a sourceFile using \a scaleFactor. The scaled image is stored to the \a targetFile or
    if \a targetFile is not given, then a temporary file is created for saving.

    The \a scaleFactor argument must be greater than 0 and less than 1. This function returns path to the
    scaled image. Note that if user doesn't specify \a targetFile the scaled image is stored under temp
    directory. Nothing guarantees that created file will remain in that diretory forewer so the caller is
    reponsible of copying file for more permanent storing.

    Returns a path to the scaled image.

    It is also recommended that if the caller doesn't use the scaled file, which is stored to the temp
    directory later, the caller should remove the file.
 */
QString ImageOperation::scaleImage(const QString &sourceFile, qreal scaleFactor, const QString &targetFile)
{
    if ( scaleFactor <= 0.0  || 1.0 <= scaleFactor) {
        qWarning() << Q_FUNC_INFO << "Argument scaleFactor needs to be 0 < scale factor < 1";
        return QString();
    }

    if (!QFile::exists(sourceFile)) {
        qWarning() << Q_FUNC_INFO << sourceFile << "doesn't exist!";
        return QString();
    }

    QString tmpFile = targetFile;
    if (tmpFile.isEmpty()) {
        tmpFile = uniqueFilePath(sourceFile);
    }

    // Using just basic QImage scale here. We can easily replace this implementation later, if we notice
    // performance bottlenecks here.
    QImage tmpImg(sourceFile);
    if (tmpImg.isNull()) {
        qWarning() << Q_FUNC_INFO << "Null source image!";
        return QString();
    }

    QImage scaled = tmpImg.scaled(tmpImg.size() * scaleFactor, Qt::KeepAspectRatio, Qt::SmoothTransformation);

    if (!scaled.save(tmpFile)) {
        qWarning() << Q_FUNC_INFO << "Failed to save scaled image to temp file!";
        return QString();
    }

    return tmpFile;
}
