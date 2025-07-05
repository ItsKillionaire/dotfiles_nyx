#!/bin/bash

# --- Configuration ---
OCR_LANG="eng" # Change to your desired language (e.g., "spa" for Spanish, "fra" for French)
# You might need to install additional Tesseract language data packages:
# For example, on Arch Linux:
# sudo pacman -S tesseract-data-eng tesseract-data-spa tesseract-data-fra

TEMP_DIR=$(mktemp -d)
SCREENSHOT_PATH="${TEMP_DIR}/screenshot.png"
TEXT_OUTPUT_PATH="${TEMP_DIR}/output.txt"
HYPRSHOT_DEBUG_LOG="${TEMP_DIR}/hyprshot_debug.log"

# --- Error Handling ---
# Function to display error notifications and exit
die() {
    notify-send "OCR Screenshot Error" "$1"
    exit 1
}

# --- Cleanup Function ---
# Ensures the temporary directory and its contents are removed when the script exits
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT # Register the cleanup function to run on script exit

# --- Take Screenshot with hyprshot ---
# Explicitly passing critical Wayland environment variables to hyprshot.
# This helps when the script's environment might be more limited than your interactive shell.
WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-0}" # Use existing or default
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" # Use existing or default UID

# Execute hyprshot with environment variables.
# We're temporarily removing --silent and piping stderr/stdout to a debug log for better diagnostics.
# If it starts working reliably and you want notifications suppressed, you can add '--silent' back
# and change '2>&1 | tee -a' to just '> /dev/null 2>&1' for hyprshot.
bash -c "WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR /usr/bin/hyprshot -m region -f screenshot.png -o \"$TEMP_DIR\"" 2>&1 | tee -a "$HYPRSHOT_DEBUG_LOG" || \
    die "Failed to take screenshot with hyprshot. Check logs for details: $HYPRSHOT_DEBUG_LOG"

# Check if the screenshot file was actually created (in case user cancelled selection)
if [ ! -f "$SCREENSHOT_PATH" ]; then
    notify-send "OCR Screenshot Cancelled" "Screenshot selection cancelled by user."
    exit 0 # Exit gracefully if user cancelled
fi

# --- Image Preprocessing for OCR (Improved) ---
# Tesseract accuracy heavily depends on image quality. These ImageMagick commands
# are designed to prepare the image for optimal OCR results.
#
# Explanation of commands:
# -modulate 100,0: Converts the image to grayscale (100% brightness, 0% saturation). Grayscale is better than color for OCR.
# -resize 600%: Scales the image up by 600%. This increases DPI, which is crucial for small text. Adjust (e.g., 400%-800%) based on text size.
# -sharpen 0x1: Applies a subtle sharpen filter. Helps define text edges.
# -auto-threshold Otsu: Automatically determines the best threshold for converting the image to pure black and white.
#                      This is generally more robust than a fixed percentage (-threshold 50%).
# -despeckle: Reduces minor noise and speckles, which can confuse Tesseract.
# -deskew 40%: Automatically corrects rotation up to 40 degrees. Essential if your selected areas are sometimes slightly angled.
#              (If you mostly capture perfectly horizontal text, you could remove this for a tiny performance gain).
mogrify -modulate 100,0 -resize 600% -sharpen 0x1 -auto-threshold Otsu -despeckle -deskew 40% "$SCREENSHOT_PATH" || \
    die "Failed to preprocess image with ImageMagick. Ensure imagemagick is installed."

# --- Perform OCR with Tesseract ---
# We're adding '--psm 6' (Page Segmentation Mode 6).
# This tells Tesseract to assume the image contains a single uniform block of text,
# which is often ideal for user-selected regions.
# Other useful PSM modes:
# - 7: Treat the image as a single text line.
# - 3 (default): Fully automatic page segmentation (might be less accurate for specific selections).
tesseract "$SCREENSHOT_PATH" "$TEXT_OUTPUT_PATH" -l "$OCR_LANG" --psm 6 &> /dev/null || \
    die "Failed to extract text with Tesseract. Ensure tesseract-ocr and '$OCR_LANG' language data are installed."

# --- Copy Extracted Text to Wayland Clipboard ---
if [ -s "${TEXT_OUTPUT_PATH}.txt" ]; then
    wl-copy < "${TEXT_OUTPUT_PATH}.txt" || \
        die "Failed to copy text to Wayland clipboard. Ensure wl-clipboard is installed."
    notify-send "OCR Screenshot Complete" "Extracted text copied to clipboard!"
else
    notify-send "OCR Screenshot Info" "No text was detected or extracted from the selected area."
fi
