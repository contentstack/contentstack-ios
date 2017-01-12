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
#${PROJECT_NAME}
UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

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

IPHONE_DEVICE_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos

# Build the other (non-simulator) platform
xcodebuild -project "${PROJECT_FILE_PATH}" -target "${SF_TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/arm64" SYMROOT="${SYMROOT}" ARCHS='arm64' VALID_ARCHS='arm64' $ACTION

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${SF_TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/armv7" SYMROOT="${SYMROOT}" ARCHS='armv7 armv7s' VALID_ARCHS='armv7 armv7s' $ACTION

# Copy the framework structure to the universal folder (clean it first)
rm -rf "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${SF_TARGET_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework"

# Copy the resource bundle to the universal folder
#cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${SF_TARGET_NAME}.bundle" "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.bundle"
rm -r "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework/Info.plist"

# Smash them together to combine all architectures
lipo -create  "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/arm64/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/armv7/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" -output "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}"


