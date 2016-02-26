---
title: "Print merge on Google Drive with autoCrat"
description: "Print merge on Google Drive with autoCrat"
layout: post
categories : [Productivity]
tagline: ''
tags : [print merge, google drive, autocrat, invoices, google app scripts]
author: tagliala
blog: true
---
{% include JB/setup.html %}

We were looking for a way to create simple invoices using a "print merge" approach that wouldn't require offline software. We wanted a solution on the cloud, free, compatible with Google Drive and possibly open source.

<!--more-->

### Update! February, 25th 2016
You should use the last version of autoCrat. Examples here are not up to date, sorry.

### Update! May, 4th 2015
After April 20th, autoCrat script stopped working again. Here it is a fix:

Go to Tools -> Script Editor. Then go to Edit -> Find and replace.

* Find `DocsList` and replace all with `DriveApp`
* Find `"document"` (both lowercase and uppercase, with quotes) and replace all with `MimeType.GOOGLE_DOCS`
* Find `getFileType` and replace all with `getMimeType`
* Find `file.addToFolder(folder)` and replace all with `folder.addFile(file)`
* Find `copy.addToFolder(parent)` and replace with `parent.addFile(copy)`
* Find `pdfFile.addToFolder(secondaryFolder)` and replace with `secondaryFolder.addFile(pdfFile)`
* Find `file.addToFolder(secondaryFolder)` and replace with `secondaryFolder.addFile(file)`
* Find `copy.removeFromFolder(root)` and replace with `DriveApp.removeFile(copy)`
* Find `pdfFile.removeFromFolder(DriveApp.getRootFolder())` and replace with `DriveApp.removeFile(pdfFile)`
* Find `file.removeFromFolder(DriveApp.getRootFolder())` and replace with `DriveApp.removeFile(file)`

Credits: [ReferenceError: "DocsList" is not defined](https://code.google.com/p/google-apps-script-issues/issues/detail?id=5017)

### Update! October, 13th 2014
After September 30th, autoCrat script stopped working. Here it is a simple fix:

Go to Tools -> Script Editor. Then go to Edit -> Find and replace.

* Find `createDecordatedPopupPanel` and replace all with `createPopupPanel`.
* Find `DocsListDialog()` and replace all with `DocsListDialog().setOAuthToken(ScriptApp­.getOAuthToken())`.

Credits:
[Having trouble with Autocrat...](https://plus.google.com/u/0/+RhondaJenkins61/posts/fsNTY9zu6Q2)
[Fix for Failed UI on Drive Picker for autoCrat, Doctopus, and formRat](https://www.youtube.com/watch?v=On52heyNLPI)

---

Fortunately there is [autoCrat](http://cloudlab.newvisions.org/scripts/autocrat), a [Google Apps Script](https://developers.google.com/apps-script/) that meets our requirements and we want to share our experience.

autoCrat has a very good documentation and a video tutorial, it was very simple to setup and use. There are some issues with formatted fields (dates, currencies...) but we found a very simple workaround. Let's say the field `B2` contains January, 20th 2014 (in date format). autoCrat will produce **Mon Jan 20 2014 00:00:00 GMT+0100 (CET)**. You can add a new cell with the formula `=TEXT(B2; "mm-dd-yyyy")` and instruct autoCrat to use the new column. We did the same thing for money values (`=TEXT(F2; "$ #,###.00")`). After doing this, you can hide these "helpers" columns in the spreadsheet.

A working example is available [in this Google Drive shared folder](https://drive.google.com/folderview?id=0B1PWGPmnhgWhU2dtd3k0RVpwQzA&usp=drive_web)

All comments and suggestions are welcome.

<small>Names, addresses and companies were generated via [Fake Name Generator](http://www.fakenamegenerator.com/)</small>
