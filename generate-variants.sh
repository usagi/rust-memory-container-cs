#!/bin/sh
# Requirement: `convert` command of ImageMagick

ORIGINAL_PREFIX="rust-memory-container-cs"
ORIGINAL_RESOLUTION="3840x2160"
VARIANT_RESOLUTIONS=( "1920x1080" "1280x720" "192x108" )

make_original_filename()
{
 # OUT
 ORIGINAL_FILENAME="${ORIGINAL_PREFIX}.png"
 echo $ORIGINAL_FILENAME
}

make_variant_filename()
{
 # IN
 VARIANT_RESOLUTION=$1
 VARIANT_SUFFIX=$2
 # OUT
 mkdir -p ${VARIANT_RESOLUTION}
 VARIANT_FILENAME="${VARIANT_RESOLUTION}/${ORIGINAL_PREFIX}-${VARIANT_RESOLUTION}-${VARIANT_SUFFIX}.png"
 echo $VARIANT_FILENAME
}

make_variants()
{
 # IN
 VARIANT_OPTIONS=$1
 VARIANT_SUFFIX=$2
 # TMP
 ORIGINAL_FILENAME=$(make_original_filename)
 VARIANT_FILENAME_0=$(make_variant_filename $ORIGINAL_RESOLUTION $VARIANT_SUFFIX)
 echo "[${ORIGINAL_RESOLUTION}] convert $ORIGINAL_FILENAME $VARIANT_OPTIONS $VARIANT_FILENAME_0"
 convert $ORIGINAL_FILENAME $VARIANT_OPTIONS $VARIANT_FILENAME_0
 for VARIANT_RESOLUTION_N in "${VARIANT_RESOLUTIONS[@]}"
 do
  VARIANT_FILENAME_N=$(make_variant_filename $VARIANT_RESOLUTION_N $VARIANT_SUFFIX)
  echo "[${VARIANT_RESOLUTION_N}] convert $VARIANT_FILENAME_0 -resize $VARIANT_RESOLUTION_N $VARIANT_FILENAME_N"
  convert $VARIANT_FILENAME_0 -resize $VARIANT_RESOLUTION_N $VARIANT_FILENAME_N
 done
}

make_variants "-define modulate:colorspace=HSL" "dark-back"
make_variants "+contrast -modulate 50" "dark-back-low-contrast"
make_variants "-contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -modulate 100" "dark-back-high-contrast"
make_variants "-contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -modulate 200 -monochrome" "black-back-white-ink"
make_variants "-contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -modulate 200 -monochrome -negate" "white-back-black-ink"
make_variants "-channel RGB -negate -define modulate:colorspace=HSL -modulate 100,100,0" "light-back"
make_variants "-channel RGB -negate -define modulate:colorspace=HSL -modulate 100,50,0" "light-back-low-contrast"
make_variants "-channel RGB -negate -define modulate:colorspace=HSL -modulate 75,800,0 -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -contrast -define modulate:colorspace=RGB" "light-back-high-contrast"
make_variants "+contrast +contrast -modulate 150" "grey-back"
make_variants "+contrast +contrast -modulate 150 +contrast +contrast +contrast -modulate 50" "grey-back-low-contrast"
make_variants "+contrast +contrast -modulate 150 -define modulate:colorspace=HSL -modulate 100,400,100" "grey-back-high-contrast"
