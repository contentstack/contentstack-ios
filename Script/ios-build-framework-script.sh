#${PROJECT_DIR}/Script/ios-build-framework-script.sh
set -e
set +u
# Avoid recursively calling this script.
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export SF_MASTER_SCRIPT_RUNNING=1

if [ "$CONFIGURATION" == "Debug" ]; then
exit 0
fi

# Constants
SF_TARGET_NAME=${TARGET_NAME}
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal
IPHONE_DEVICE_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos

# Take build target
if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
then
SF_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SF_SDK_PLATFORM" = "iphoneos" ]]
then
echo "Please choose iPhone simulator as the build target."
exit 1
fi


# Build the other (non-simulator) platform
xcodebuild -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${SF_TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}/DependantBuilds/arm64" BUILD_ROOT="${BUILD_ROOT}" CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/arm64" SYMROOT="${SYMROOT}" ARCHS='arm64' VALID_ARCHS='arm64' $ACTION

xcodebuild -workspace "${PROJECT_NAME}.xcworkspace" -scheme "${SF_TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}/DependantBuilds/arm7" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/armv7" SYMROOT="${SYMROOT}" ARCHS='armv7 armv7s' VALID_ARCHS='armv7 armv7s' $ACTION

# Copy the framework structure to the universal folder (clean it first)
rm -rf "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Copy iPhone Simulator framework to Universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${SF_TARGET_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework"

# Remove Info.plist file from universal folder
rm -r "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework/Info.plist"

# Smash them together to combine all architectures
lipo -create  "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/arm64/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/armv7/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" -output "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}"

#Convenience step to copy the framework to the project's directory
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework" "${PROJECT_DIR}/Build"
cp -R "${BUILD_DIR}" "${PROJECT_DIR}/Build"
cp -R "${OBJROOT}" "${PROJECT_DIR}/Build"

#Convenience step to open the project's directory in Finder
open "${PROJECT_DIR}/Build"
