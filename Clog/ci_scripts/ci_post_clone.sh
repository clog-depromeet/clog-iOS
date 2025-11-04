#!/bin/sh
set -e

echo "🔧 Making tuist_install.sh executable..."
chmod +x tuist_install.sh

echo "🚀 Running tuist_install.sh..."
./tuist_install.sh

echo "✅ ci_post_clone.sh completed successfully"