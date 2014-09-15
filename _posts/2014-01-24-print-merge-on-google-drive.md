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

Fortunately there is [autoCrat](http://cloudlab.newvisions.org/scripts/autocrat), a [Google Apps Script](https://developers.google.com/apps-script/) that meets our requirements and we want to share our experience.

autoCrat has a very good documentation and a video tutorial, it was very simple to setup and use. There are some issues with formatted fields (dates, currencies...) but we found a very simple workaround. Let's say the field `B2` contains January, 20th 2014 (in date format). autoCrat will produce **Mon Jan 20 2014 00:00:00 GMT+0100 (CET)**. You can add a new cell with the formula `=TEXT(B2; "mm-dd-yyyy")` and instruct autoCrat to use the new column. We did the same thing for money values (`=TEXT(F2; "$ #,###.00")`). After doing this, you can hide these "helpers" columns in the spreadsheet.

A working example is available [in this Google Drive shared folder](https://drive.google.com/folderview?id=0B1PWGPmnhgWhU2dtd3k0RVpwQzA&usp=drive_web)

All comments and suggestions are welcome.

<small>Names, addresses and companies were generated via [Fake Name Generator](http://www.fakenamegenerator.com/)</small>
