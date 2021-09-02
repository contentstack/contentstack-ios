#!/bin/sh

#  run-test-case.sh
#  Contentstack
#
#  Created by Uttam Ukkoji on 09/06/20.
#  Copyright © 2020 Contentstack. All rights reserved.

set -o pipefail && env "NSUnbufferedIO=YES" xcodebuild "-workspace" "ContentStack.xcworkspace" "-scheme" "Contentstack" "build" "test" "-destination" "id=122C1770-2736-4869-98C2-118EF3B37850" | xcpretty "--color" "--report" "html" "--output" "/Users/uttamukkoji/Documents/GitHub/contentstack-ios/ContentstackTest/TestResult/xcode-test-results-Contentstack.html"
