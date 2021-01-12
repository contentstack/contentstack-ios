#!/bin/sh

#  run-test-case.sh
#  Contentstack
#
#  Created by Uttam Ukkoji on 09/06/20.
#  Copyright © 2020 Contentstack. All rights reserved.

set -o pipefail && env "NSUnbufferedIO=YES" xcodebuild "-workspace" "ContentStack.xcworkspace" "-scheme" "Contentstack" "build" "test" "-destination" "id=7307CFB4-C3C3-49C9-A051-FE29727D6742" | xcpretty "--color" "--report" "html" "--output" "/Users/uttamukkoji/Documents/GitHub/contentstack-ios/ContentstackTest/TestResult/xcode-test-results-Contentstack.html"
