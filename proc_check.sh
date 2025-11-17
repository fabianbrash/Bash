#!/bin/bash

# Define the required flags for x86-64-v2
REQUIRED_FLAGS=("sse4_2" "popcnt")
MISSING_FLAGS=()
CPUINFO_FILE="/proc/cpuinfo"

echo "🔎 Checking CPU for required x86-64-v2 features..."
echo "----------------------------------------------------"

# Check if the flags are present in cpuinfo
for flag in "${REQUIRED_FLAGS[@]}"; do
    if ! grep -q "\<$flag\>" $CPUINFO_FILE; then
        MISSING_FLAGS+=("$flag")
    fi
done

# Report the results
if [ ${#MISSING_FLAGS[@]} -eq 0 ]; then
    echo "✅ SUCCESS: All required flags (sse4_2, popcnt) are present."
    echo "   This node should be compatible with modern GLIBC applications (e.g., MinIO)."
    exit 0
else
    echo "❌ ERROR: The following critical CPU flags are MISSING: ${MISSING_FLAGS[@]}"
    echo "   This node is NOT x86-64-v2 compliant. Containers requiring modern GLIBC may fail."
    echo "   Action: Check your Hypervisor settings to ensure CPU feature passthrough is enabled."
    exit 1
fi
