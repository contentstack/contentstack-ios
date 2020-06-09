#!/bin/sh

#  run-test-case.sh
#  Contentstack
#
#  Created by Uttam Ukkoji on 09/06/20.
#  Copyright © 2020 Contentstack. All rights reserved.

set -o pipefail && env "NSUnbufferedIO=YES" xcodebuild "-workspace" "ContentStack.xcworkspace" "-scheme" "Contentstack" "build" "test" "-destination" "id=5A6F1642-DAB2-4583-B19C-0068614B7420" | xcpretty "--color" "--report" "html" "--output" "/Users/uttamukkoji/Documents/GitHub/contentstack-ios/ContentstackTest/TestResult/xcode-test-results-Contentstack.html"
