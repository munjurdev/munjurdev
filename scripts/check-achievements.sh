#!/bin/bash
# GitHub Achievement Checker
# Checks which achievements a user has earned and outputs badge names

USERNAME="${1:-munjurdev}"
PROFILE_URL="https://github.com/${USERNAME}"

echo "🔍 Checking achievements for ${USERNAME}..."

# Fetch profile page
PROFILE_HTML=$(curl -s "${PROFILE_URL}")

# Check for common achievements by looking for achievement images
declare -A ACHIEVEMENTS

# Achievement image patterns (GitHub uses these in profile)
declare -A BADGE_IMAGES=(
    ["pull-shark"]="pull-shark"
    ["galaxy-brain"]="galaxy-brain"
    ["starstruck"]="starstruck"
    ["quickdraw"]="quickdraw"
    ["pair-extraordinaire"]="pair-extraordinaire"
    ["yolo"]="yolo"
    ["arctic-code-vault-contributor"]="arctic-code-vault-contributor"
    ["public-sponsor"]="public-sponsor"
    ["heart-on-your-sleeve"]="heart-on-your-sleeve"
    ["open-sourcerer"]="open-sourcerer"
)

# Initialize earned badges array
EARNED_BADGES=()

# Check each achievement
for badge in "${!BADGE_IMAGES[@]}"; do
    badge_name="${BADGE_IMAGES[$badge]}"
    if echo "$PROFILE_HTML" | grep -q "${badge_name}"; then
        EARNED_BADGES+=("${badge_name}")
        echo "✅ Found: ${badge_name}"
    fi
done

# Output earned badges
echo ""
echo "📊 Summary: ${#EARNED_BADGES[@]} achievements found"

# Generate badge HTML for README
BADGE_HTML=""
for badge in "${EARNED_BADGES[@]}"; do
    # Determine tier (check for bronze/silver/gold)
    TIER="default"
    if echo "$PROFILE_HTML" | grep -q "${badge}.*gold\|${badge}.*Gold"; then
        TIER="gold"
    elif echo "$PROFILE_HTML" | grep -q "${badge}.*silver\|${badge}.*Silver"; then
        TIER="silver"
    elif echo "$PROFILE_HTML" | grep -q "${badge}.*bronze\|${badge}.*Bronze"; then
        TIER="bronze"
    fi
    
    BADGE_HTML="${BADGE_HTML}\n<img src=\"https://github.githubassets.com/images/modules/profile/achievements/${badge}-${TIER}.png\" width=\"60\" height=\"60\" alt=\"${badge}\" title=\"${badge}\" />"
done

# Save to file for GitHub Action to use
echo -e "$BADGE_HTML" > profile/achievements-badges.txt
echo "✅ Badges saved to profile/achievements-badges.txt"

# Print earned badges
echo ""
echo "🎯 Earned badges:"
for badge in "${EARNED_BADGES[@]}"; do
    echo "  - ${badge}"
done
