#!/bin/sh
set -e
cd ..

curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"

echo "❗️Current PATH: $PATH"

echo "❗️mise version"
mise --version
echo "❗️mise install"
mise install
eval "$(mise activate bash --shims)"

echo "❗️tuist install"
tuist install
echo "❗️tuist generate"
tuist generate --no-open
