#!/bin/sh

#  DocGenerationScript.sh
#  contentstack
#
#  Created by Reefaq on 12/01/17.
#  Copyright © 2017 Contentstack. All rights reserved.

#--keep-undocumented-objects \
#--keep-undocumented-members \

#appledoc Xcode script
# Start constants
company="Contentstack";
companyForFeed="Contentstack";
companyID="com.contentstack.com";
companyURL="http://contentstack.com";
target="iphoneos";
#target="macosx";
#outputPath ="./../../Contentstack-Xcode-Generated-Docs/helpdocs";
#outputPath ="~/CSIOiOSDOC";
#overviewPath ="./../../Contentstack-Xcode-Generated-Docs/Overview.md";
#--publish-docset \
# End constants
/usr/local/bin/appledoc \
--project-name "Contentstack" \
--project-company "Contentstack.com" \
--project-version "3.9.1" \
--company-id "${companyID}" \
--docset-bundle-id "${companyID}.${companyForFeed}" \
--docset-bundle-name "${companyForFeed}" \
--docset-bundle-filename "${companyForFeed}.docset" \
--docset-package-filename "${companyForFeed}" \
--docset-feed-name "${companyForFeed}" \
--docset-atom-filename "${companyForFeed}.atom" \
--docset-feed-url "${companyURL}/${companyForFeed}/%DOCSETATOMFILENAME" \
--docset-package-url "${companyURL}/${companyForFeed}/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "${companyURL}/${companyForFeed}" \
--output "${PROJECT_DIR}/Build/CSIOiOSDOC" \
--docset-platform-family "${target}" \
--logformat xcode \
--merge-categories \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--index-desc "${PROJECT_DIR}/Docs/overview.md" \
--exit-threshold 2 \
./Build/Products/Release-universal/Contentstack.framework/Headers
