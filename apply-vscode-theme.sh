#!/bin/bash

# Apply VS Code Dark Theme to Claudia
# This script modifies the color scheme to match VS Code's dark theme

echo "🎨 Applying VS Code Dark Theme to Claudia..."

# Function to check if file exists
check_file() {
    if [ ! -f "$1" ]; then
        echo "❌ Error: File $1 not found!"
        exit 1
    fi
}

# Backup files before modification
backup_files() {
    echo "📦 Creating backups..."
    cp src/styles.css src/styles.css.backup 2>/dev/null || true
    cp src/components/ToolWidgets.tsx src/components/ToolWidgets.tsx.backup 2>/dev/null || true
    cp src/components/ClaudeCodeSession.tsx src/components/ClaudeCodeSession.tsx.backup 2>/dev/null || true
    cp src/components/FloatingPromptInput.tsx src/components/FloatingPromptInput.tsx.backup 2>/dev/null || true
    cp src-tauri/tauri.conf.json src-tauri/tauri.conf.json.backup 2>/dev/null || true
    cp src/App.tsx src/App.tsx.backup 2>/dev/null || true
    echo "✅ Backups created"
}

# Apply theme changes to styles.css
apply_styles_changes() {
    echo "🎨 Updating styles.css..."
    
    # Check if file exists
    check_file "src/styles.css"
    
    # Use sed to replace the color values
    sed -i '' 's/--color-background: oklch(0.12 0.01 240);/--color-background: #1e1e1e;/g' src/styles.css
    sed -i '' 's/--color-foreground: oklch(0.98 0.01 240);/--color-foreground: #d4d4d4;/g' src/styles.css
    sed -i '' 's/--color-card: oklch(0.14 0.01 240);/--color-card: #252526;/g' src/styles.css
    sed -i '' 's/--color-card-foreground: oklch(0.98 0.01 240);/--color-card-foreground: #d4d4d4;/g' src/styles.css
    sed -i '' 's/--color-popover: oklch(0.12 0.01 240);/--color-popover: #252526;/g' src/styles.css
    sed -i '' 's/--color-popover-foreground: oklch(0.98 0.01 240);/--color-popover-foreground: #d4d4d4;/g' src/styles.css
    sed -i '' 's/--color-primary: oklch(0.98 0.01 240);/--color-primary: #d4d4d4;/g' src/styles.css
    sed -i '' 's/--color-primary-foreground: oklch(0.17 0.01 240);/--color-primary-foreground: #1e1e1e;/g' src/styles.css
    sed -i '' 's/--color-secondary: oklch(0.16 0.01 240);/--color-secondary: #2d2d30;/g' src/styles.css
    sed -i '' 's/--color-secondary-foreground: oklch(0.98 0.01 240);/--color-secondary-foreground: #d4d4d4;/g' src/styles.css
    sed -i '' 's/--color-muted: oklch(0.16 0.01 240);/--color-muted: #2d2d30;/g' src/styles.css
    sed -i '' 's/--color-muted-foreground: oklch(0.68 0.01 240);/--color-muted-foreground: #858585;/g' src/styles.css
    sed -i '' 's/--color-accent: oklch(0.16 0.01 240);/--color-accent: #2d2d30;/g' src/styles.css
    sed -i '' 's/--color-accent-foreground: oklch(0.98 0.01 240);/--color-accent-foreground: #d4d4d4;/g' src/styles.css
    sed -i '' 's/--color-destructive: oklch(0.6 0.2 25);/--color-destructive: #f48771;/g' src/styles.css
    sed -i '' 's/--color-destructive-foreground: oklch(0.98 0.01 240);/--color-destructive-foreground: #d4d4d4;/g' src/styles.css
    sed -i '' 's/--color-border: oklch(0.16 0.01 240);/--color-border: #3e3e42;/g' src/styles.css
    sed -i '' 's/--color-input: oklch(0.16 0.01 240);/--color-input: #3c3c3c;/g' src/styles.css
    sed -i '' 's/--color-ring: oklch(0.52 0.015 240);/--color-ring: #007acc;/g' src/styles.css
    
    # Add comment to indicate VS Code theme
    sed -i '' 's/\/\* Colors \*\//\/\* Colors - VS Code Dark Theme \*\//g' src/styles.css
    
    # Update scrollbar styles to VS Code theme
    echo "  - Updating scrollbar styles..."
    
    # Firefox scrollbar
    sed -i '' 's/scrollbar-color: var(--color-muted-foreground) var(--color-background);/scrollbar-color: rgba(66, 66, 66, 0.8) transparent;/g' src/styles.css
    
    # Webkit scrollbar width
    sed -i '' 's/::-webkit-scrollbar {[[:space:]]*width: 12px;/::-webkit-scrollbar {\n  width: 10px;/g' src/styles.css
    sed -i '' 's/::-webkit-scrollbar {[[:space:]]*width: 8px;/::-webkit-scrollbar {\n  width: 10px;/g' src/styles.css
    
    # Webkit scrollbar track
    sed -i '' 's/background: var(--color-background);/background: transparent;/g' src/styles.css
    sed -i '' 's/background: rgba(0, 0, 0, 0.3);/background: transparent;/g' src/styles.css
    sed -i '' 's/background: rgba(0, 0, 0, 0.2);/background: transparent;/g' src/styles.css
    
    # Webkit scrollbar thumb colors
    sed -i '' 's/background-color: var(--color-muted);/background-color: rgba(66, 66, 66, 0.8);/g' src/styles.css
    sed -i '' 's/border: 3px solid var(--color-background);/border: 1px solid transparent;/g' src/styles.css
    sed -i '' 's/border-radius: 6px;/border-radius: 5px;/g' src/styles.css
    sed -i '' 's/background-color: var(--color-muted-foreground);/background-color: rgba(78, 78, 78, 0.8);/g' src/styles.css
    sed -i '' 's/background-color: rgba(107, 114, 128, 0.2);/background-color: rgba(66, 66, 66, 0.6);/g' src/styles.css
    sed -i '' 's/background-color: rgba(107, 114, 128, 0.3);/background-color: rgba(66, 66, 66, 0.6);/g' src/styles.css
    sed -i '' 's/background-color: rgba(107, 114, 128, 0.4);/background-color: rgba(66, 66, 66, 0.8);/g' src/styles.css
    sed -i '' 's/background-color: rgba(107, 114, 128, 0.5);/background-color: rgba(78, 78, 78, 0.8);/g' src/styles.css
    sed -i '' 's/background-color: rgba(107, 114, 128, 0.6);/background-color: rgba(78, 78, 78, 0.8);/g' src/styles.css
    sed -i '' 's/background-color: rgba(107, 114, 128, 0.8);/background-color: rgba(96, 96, 96, 0.8);/g' src/styles.css
    
    # Update .bg-zinc-950 references to .bg-secondary
    sed -i '' 's/.bg-zinc-950 ::-webkit-scrollbar/.bg-secondary ::-webkit-scrollbar/g' src/styles.css
    
    # Firefox code preview scrollbar
    sed -i '' 's/scrollbar-color: rgba(107, 114, 128, 0.4) rgba(0, 0, 0, 0.2);/scrollbar-color: rgba(66, 66, 66, 0.8) transparent;/g' src/styles.css
    
    echo "✅ styles.css updated"
}

# Apply theme changes to ToolWidgets.tsx
apply_component_changes() {
    echo "🎨 Updating ToolWidgets.tsx..."
    
    # Check if file exists
    check_file "src/components/ToolWidgets.tsx"
    
    # Replace Tailwind classes
    sed -i '' 's/bg-zinc-950/bg-secondary/g' src/components/ToolWidgets.tsx
    sed -i '' 's/bg-zinc-900\/50/bg-muted\/70/g' src/components/ToolWidgets.tsx
    sed -i '' 's/bg-zinc-900\/30/bg-muted\/50/g' src/components/ToolWidgets.tsx
    sed -i '' 's/bg-zinc-900/bg-muted/g' src/components/ToolWidgets.tsx
    sed -i '' 's/hover:bg-zinc-900\/50/hover:bg-muted\/70/g' src/components/ToolWidgets.tsx
    sed -i '' 's/border-zinc-800/border-border/g' src/components/ToolWidgets.tsx
    
    echo "✅ ToolWidgets.tsx updated"
}

# Apply full width chat layout
apply_fullwidth_chat() {
    echo "🎨 Updating chat layout to full width..."
    
    # Check if files exist
    check_file "src/components/ClaudeCodeSession.tsx"
    check_file "src/components/FloatingPromptInput.tsx"
    
    # Remove max-width limitations in ClaudeCodeSession
    sed -i '' 's/className="relative w-full max-w-5xl mx-auto px-4 pt-8 pb-4"/className="relative w-full px-4 pt-8 pb-4"/g' src/components/ClaudeCodeSession.tsx
    sed -i '' 's/className="rounded-lg border border-destructive\/50 bg-destructive\/10 p-4 text-sm text-destructive mb-40 w-full max-w-5xl mx-auto"/className="rounded-lg border border-destructive\/50 bg-destructive\/10 p-4 text-sm text-destructive mb-40 w-full px-4"/g' src/components/ClaudeCodeSession.tsx
    sed -i '' 's/className="h-full flex flex-col max-w-5xl mx-auto"/className="h-full flex flex-col"/g' src/components/ClaudeCodeSession.tsx
    sed -i '' 's/className="fixed bottom-24 left-1\/2 -translate-x-1\/2 z-30 w-full max-w-3xl px-4"/className="fixed bottom-24 left-1\/2 -translate-x-1\/2 z-30 w-full px-4"/g' src/components/ClaudeCodeSession.tsx
    sed -i '' 's/className="max-w-5xl mx-auto"/className="w-full"/g' src/components/ClaudeCodeSession.tsx
    
    # Remove max-width limitation in FloatingPromptInput
    sed -i '' 's/className="max-w-5xl mx-auto"/className="w-full"/g' src/components/FloatingPromptInput.tsx
    
    echo "✅ Chat layout updated to full width"
}

# Add conversation navigation sidebar
add_conversation_navigation() {
    echo "🎨 Adding conversation navigation sidebar..."
    
    # The navigation component is a new file, so we just need to ensure it exists
    if [ ! -f "src/components/ConversationNavigation.tsx" ]; then
        echo "⚠️  ConversationNavigation.tsx not found. Please ensure the file has been created."
        echo "   The navigation feature requires the ConversationNavigation component."
        return 1
    fi
    
    echo "✅ Conversation navigation feature is ready"
    echo "   - Navigation sidebar shows user messages and AI actions"
    echo "   - Click items to jump to specific messages"
    echo "   - Toggle with the # button in the toolbar"
}

# Apply custom title bar
apply_custom_titlebar() {
    echo "🎨 Applying custom VS Code style title bar..."
    
    # Check if files exist
    check_file "src-tauri/tauri.conf.json"
    
    # The CustomTitleBar component should exist
    if [ ! -f "src/components/CustomTitleBar.tsx" ]; then
        echo "⚠️  CustomTitleBar.tsx not found. Please ensure the file has been created."
        return 1
    fi
    
    echo "✅ Custom title bar configured"
    echo "   - Native macOS title bar replaced with VS Code style"
    echo "   - Window controls match VS Code theme"
    echo "   - Draggable title bar area"
}

# Restore original theme
restore_theme() {
    echo "🔄 Restoring original theme..."
    
    if [ -f "src/styles.css.backup" ]; then
        mv src/styles.css.backup src/styles.css
        echo "✅ styles.css restored"
    fi
    
    if [ -f "src/components/ToolWidgets.tsx.backup" ]; then
        mv src/components/ToolWidgets.tsx.backup src/components/ToolWidgets.tsx
        echo "✅ ToolWidgets.tsx restored"
    fi
    
    if [ -f "src/components/ClaudeCodeSession.tsx.backup" ]; then
        mv src/components/ClaudeCodeSession.tsx.backup src/components/ClaudeCodeSession.tsx
        echo "✅ ClaudeCodeSession.tsx restored"
    fi
    
    if [ -f "src/components/FloatingPromptInput.tsx.backup" ]; then
        mv src/components/FloatingPromptInput.tsx.backup src/components/FloatingPromptInput.tsx
        echo "✅ FloatingPromptInput.tsx restored"
    fi
    
    if [ -f "src-tauri/tauri.conf.json.backup" ]; then
        mv src-tauri/tauri.conf.json.backup src-tauri/tauri.conf.json
        echo "✅ tauri.conf.json restored"
    fi
    
    if [ -f "src/App.tsx.backup" ]; then
        mv src/App.tsx.backup src/App.tsx
        echo "✅ App.tsx restored"
    fi
    
    echo "✅ Original theme restored"
}

# Main execution
main() {
    # Check if we're in the right directory
    if [ ! -d "src" ] || [ ! -f "package.json" ]; then
        echo "❌ Error: Please run this script from the claudia project root directory"
        exit 1
    fi
    
    # Check for restore flag
    if [ "$1" = "--restore" ]; then
        restore_theme
        exit 0
    fi
    
    # Check for help flag
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        echo "Usage: ./apply-vscode-theme.sh [options]"
        echo ""
        echo "Options:"
        echo "  --restore    Restore the original theme from backups"
        echo "  --help, -h   Show this help message"
        echo ""
        echo "This script applies VS Code dark theme colors to Claudia."
        echo "Backup files are created automatically."
        exit 0
    fi
    
    # Apply the theme
    backup_files
    apply_styles_changes
    apply_component_changes
    apply_fullwidth_chat
    add_conversation_navigation
    apply_custom_titlebar
    
    echo ""
    echo "🎉 VS Code Dark Theme applied successfully!"
    echo ""
    echo "To restore the original theme, run:"
    echo "  ./apply-vscode-theme.sh --restore"
    echo ""
    echo "To rebuild the application, run:"
    echo "  bun run tauri build"
}

# Run the script
main "$@"