# PowerShell script for setting up Fullstack Blog (Next.js + Supabase)
# Equivalent to setup.sh but for Windows users

# Set error action preference to stop on error
$ErrorActionPreference = "Stop"

# Helper function for colored output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    else {
        $input | Write-Output
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

Write-ColorOutput Yellow "Fullstack Blog Setup (Next.js + Supabase)"
Write-Output "This script will set up your blog project with Next.js and Supabase."

# Step 1: Create a temporary directory for Next.js initialization
Write-ColorOutput Green "`nStep 1: Creating temporary directory for Next.js initialization..."
$TEMP_DIR = "temp-nextjs-setup-$(Get-Date -Format 'yyyyMMddHHmmss')"
New-Item -Path $TEMP_DIR -ItemType Directory -Force | Out-Null
Write-Output "Temporary directory created at: $TEMP_DIR"

# Step 2: Initialize Next.js in the temporary directory
Write-ColorOutput Green "`nStep 2: Initializing Next.js in temporary directory..."
Set-Location -Path $TEMP_DIR
npx --registry=https://registry.npmjs.org/ create-next-app@latest . `
  --typescript `
  --tailwind `
  --eslint `
  --app `
  --src-dir `
  --import-alias "@/*" `
  --use-npm

# Step 3: Copy Next.js files back to the current project directory
Write-ColorOutput Green "`nStep 3: Copying Next.js files to project directory..."
Set-Location -Path ..

# Create an array of files to preserve
$PRESERVE_FILES = @(
  ".nvmrc",
  ".npmrc",
  ".cursor\.cursorrules",
  ".cursor\tasks\init.md",
  "README.md",
  ".env.local",
  ".env.example",
  "setup.sh",
  "setup.ps1"
)

# Copy all files from temp directory except those we want to preserve
$SOURCE_DIR = Join-Path -Path $PWD -ChildPath $TEMP_DIR
$ITEMS = Get-ChildItem -Path $SOURCE_DIR -Recurse -Force

foreach ($ITEM in $ITEMS) {
    $RELATIVE_PATH = $ITEM.FullName.Substring($SOURCE_DIR.Length + 1)
    
    # Skip .git and node_modules
    if ($RELATIVE_PATH -like ".git\*" -or $RELATIVE_PATH -like "node_modules\*") {
        continue
    }
    
    # Skip preserved files
    $SKIP = $false
    foreach ($FILE in $PRESERVE_FILES) {
        if ($RELATIVE_PATH -eq $FILE) {
            $SKIP = $true
            break
        }
    }
    
    if (-not $SKIP) {
        $TARGET = Join-Path -Path $PWD -ChildPath $RELATIVE_PATH
        $TARGET_DIR = Split-Path -Parent $TARGET
        
        if (-not (Test-Path -Path $TARGET_DIR)) {
            New-Item -Path $TARGET_DIR -ItemType Directory -Force | Out-Null
        }
        
        if (-not $ITEM.PSIsContainer) {
            Copy-Item -Path $ITEM.FullName -Destination $TARGET -Force
        }
    }
}

# Step 4: Install Supabase
Write-ColorOutput Green "`nStep 4: Installing Supabase client..."
try {
    npm --registry=https://registry.npmjs.org/ i @supabase/supabase-js@latest
} catch {
    Write-ColorOutput Yellow "Initial installation failed. Trying with legacy peer deps..."
    npm --registry=https://registry.npmjs.org/ i @supabase/supabase-js@latest --legacy-peer-deps
}

# Create environment files (only if they don't exist)
Write-ColorOutput Green "`nStep 5: Creating environment files..."
if (-not (Test-Path -Path ".env.local")) {
    @"
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
"@ | Out-File -FilePath ".env.local" -Encoding utf8
}

if (-not (Test-Path -Path ".env.example")) {
    @"
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
"@ | Out-File -FilePath ".env.example" -Encoding utf8
}

# Clean up temporary directory
Write-ColorOutput Green "`nCleaning up..."
try {
    Remove-Item -Path $TEMP_DIR -Recurse -Force -ErrorAction Stop
    Write-Output "Temporary directory removed successfully"
} catch {
    Write-ColorOutput Yellow "Warning: Could not remove temporary directory automatically."
    Write-ColorOutput Yellow "Please manually remove: $TEMP_DIR"
    Write-ColorOutput Yellow "You can try: Remove-Item -Path '$TEMP_DIR' -Recurse -Force"
}

Write-ColorOutput Yellow "`nSetup complete!"
Write-Output "Your Next.js + Supabase blog template is ready."
Write-Output "Run 'npm run dev' to start the development server." 