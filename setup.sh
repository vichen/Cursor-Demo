#!/bin/bash
set -e

# Colors for better output
GREEN='\033[0;32m'
BLUE='\033[1;33;40m'
NC='\033[0m' # No Color

echo -e "${BLUE}Fullstack Blog Setup (Next.js + Supabase)${NC}"
echo "This script will set up your blog project with Next.js and Supabase."

# Step 1: Create a temporary directory for Next.js initialization
echo -e "\n${GREEN}Step 1: Creating temporary directory for Next.js initialization...${NC}"
TEMP_DIR="temp-nextjs-setup-$(date +%s)"
mkdir -p $TEMP_DIR
echo "Temporary directory created at: $TEMP_DIR"

# Step 2: Initialize Next.js in the temporary directory
echo -e "\n${GREEN}Step 2: Initializing Next.js in temporary directory...${NC}"
cd $TEMP_DIR
npx --registry=https://registry.npmjs.org/ create-next-app@latest . \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --import-alias "@/*" \
  --use-npm

# Step 3: Copy Next.js files back to the current project directory
echo -e "\n${GREEN}Step 3: Copying Next.js files to project directory...${NC}"
cd -

# Create an array of files to preserve
PRESERVE_FILES=(
  ".nvmrc"
  ".npmrc"
  ".cursor/.cursorrules"
  ".cursor/cursor-tasks.md"
  "README.md"
  ".env.local"
  ".env.example"
  "setup.sh"
)

# Create exclude pattern for rsync
EXCLUDE_PATTERN=""
for file in "${PRESERVE_FILES[@]}"; do
  EXCLUDE_PATTERN="$EXCLUDE_PATTERN --exclude=$file"
done

# Copy all files from temp directory except for preserved files
rsync -av --progress $TEMP_DIR/ ./ --exclude=".git" --exclude="node_modules" $EXCLUDE_PATTERN

# Step 4: Install Supabase
echo -e "\n${GREEN}Step 4: Installing Supabase client...${NC}"
if ! npm --registry=https://registry.npmjs.org/ i @supabase/supabase-js@latest; then
    echo -e "${BLUE}Initial installation failed. Trying with legacy peer deps...${NC}"
    npm --registry=https://registry.npmjs.org/ i @supabase/supabase-js@latest --legacy-peer-deps
fi

# Create environment files (only if they don't exist)
echo -e "\n${GREEN}Step 5: Creating environment files...${NC}"
if [ ! -f .env.local ]; then
  cat > .env.local << EOF
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
EOF
fi

if [ ! -f .env.example ]; then
  cat > .env.example << EOF
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
EOF
fi

# Clean up temporary directory
echo -e "\n${GREEN}Cleaning up...${NC}"
if [ -d "$TEMP_DIR" ]; then
  # Get absolute path of temp directory
  TEMP_DIR_ABS=$(realpath "$TEMP_DIR")
  
  # Store original directory
  ORIGINAL_DIR=$(pwd)
  
  # Make sure we're in the parent directory
  cd $(dirname "$TEMP_DIR_ABS")
  
  echo "Attempting to remove: $TEMP_DIR_ABS"
  
  # Try different cleanup methods
  rm -rf "$TEMP_DIR_ABS" 2>/dev/null || \
  (cd .. && rm -rf "$TEMP_DIR_ABS") 2>/dev/null || \

  # Verify removal
  if [ -d "$TEMP_DIR_ABS" ]; then
    echo -e "${BLUE}Warning: Could not remove temporary directory automatically.${NC}"
    echo -e "${BLUE}Please manually remove: ${TEMP_DIR_ABS}${NC}"
    echo -e "${BLUE}You can try: rm -rf \"${TEMP_DIR_ABS}\"${NC}"
  else
    echo "Temporary directory removed successfully"
  fi
  
  # Return to original directory
  cd "$ORIGINAL_DIR"
fi

# Return to original directory
cd - > /dev/null

echo -e "\n${BLUE}Setup complete!${NC}"
echo "Your Next.js + Supabase blog template is ready."
echo "Run 'npm run dev' to start the development server."