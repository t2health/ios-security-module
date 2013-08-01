#!/bin/sh
lipo -create "${BUILT_PRODUCTS_DIR}/../Release-iphonesimulator/libIosAppCheck-simulator.a" \
"${BUILT_PRODUCTS_DIR}/libIosAppCheck-iphone.a" -output \
"${BUILT_PRODUCTS_DIR}/libIosAppCheck-v2.0.a"
