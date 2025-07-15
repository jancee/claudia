# Directory Structure Design

## Overview

This document outlines the directory structure of the Claudia project, explaining the purpose and contents of each major directory and file.

## Root Directory Structure

```
claudia/
├── src/                      # React frontend source code
├── src-tauri/               # Rust backend (Tauri) source code
├── public/                  # Static assets served directly
├── PRD/                     # Product Requirements Documentation
├── scripts/                 # Build and utility scripts
├── vendor/                  # Third-party dependencies
├── .claude/                 # Claude-specific configurations
├── src-tauri/binaries/      # Compiled binaries for distribution
└── configuration files...   # Various config files
```

## Frontend Structure (`src/`)

### Components Directory
```
src/components/
├── ClaudeCodeSession.tsx    # Main session interface component
├── ConversationNavigation.tsx # Sidebar navigation component
├── StreamMessage.tsx        # Message rendering component
├── ToolWidgets.tsx         # Tool output display widgets
├── AgentExecution.tsx      # Agent execution interface
├── ErrorBoundary.tsx       # Error handling wrapper
├── FloatingPromptInput.tsx # Chat input component
├── SessionList.tsx         # Session history list
├── ProjectList.tsx         # Project browser
├── CCAgents.tsx           # Custom agents interface
├── TimelineNavigator.tsx   # Session timeline feature
├── CheckpointSettings.tsx  # Checkpoint configuration
├── SlashCommandsManager.tsx # Slash commands settings
├── HooksEditor.tsx        # Hooks configuration editor
└── ui/                    # Reusable UI components
    ├── button.tsx
    ├── card.tsx
    ├── dialog.tsx
    ├── input.tsx
    ├── scroll-area.tsx
    ├── split-pane.tsx
    └── ...more components
```

### Library Directory
```
src/lib/
├── api.ts                  # Tauri command bindings
├── utils.ts               # Utility functions
├── hooks.ts               # Custom React hooks
└── types.ts               # TypeScript type definitions
```

### Assets Directory
```
src/assets/
├── icons/                 # SVG icons
├── fonts/                 # Custom fonts
└── images/               # Static images
```

### Styles
```
src/
├── styles.css            # Global styles and CSS variables
├── index.css            # Entry point styles
└── tailwind.config.js   # Tailwind CSS configuration
```

## Backend Structure (`src-tauri/`)

### Source Code
```
src-tauri/src/
├── main.rs              # Application entry point
├── commands/            # Tauri command handlers
│   ├── mod.rs
│   ├── session.rs       # Session management
│   ├── project.rs       # Project operations
│   ├── agent.rs         # Agent execution
│   └── mcp.rs          # MCP server management
├── checkpoint/          # Timeline/checkpoint system
│   ├── mod.rs
│   ├── manager.rs      # Checkpoint management
│   └── storage.rs      # Checkpoint persistence
├── process/            # Process management
│   ├── mod.rs
│   ├── claude.rs       # Claude CLI integration
│   └── agent.rs        # Agent process handling
├── database/           # Database operations
│   ├── mod.rs
│   └── migrations.rs   # SQL migrations
└── utils/              # Utility modules
    ├── mod.rs
    └── logger.rs       # Logging utilities
```

### Configuration
```
src-tauri/
├── Cargo.toml          # Rust dependencies
├── tauri.conf.json     # Tauri configuration
├── build.rs            # Build script
└── icons/              # Application icons
```

### Tests
```
src-tauri/tests/
├── integration/        # Integration tests
├── unit/              # Unit tests
└── fixtures/          # Test data
```

## Documentation (`PRD/`)

```
PRD/
├── 01-Product-Features-Requirements.md
├── 02-Technical-Architecture-Design.md
├── 03-Directory-Structure-Design.md
└── 04-API-Documentation.md
```

## Scripts Directory

```
scripts/
├── build-executables.js    # Build Claude Code binaries
├── fetch-and-build.js     # Fetch and build dependencies
├── prepare-bundle-native.js # Bundle preparation
└── dev-setup.sh           # Development environment setup
```

## Configuration Files

### Root Level Configs
```
claudia/
├── package.json           # Node.js dependencies
├── bun.lockb             # Bun lock file
├── tsconfig.json         # TypeScript configuration
├── vite.config.ts        # Vite build configuration
├── tailwind.config.js    # Tailwind CSS config
├── postcss.config.js     # PostCSS configuration
├── .gitignore           # Git ignore rules
├── .env.example         # Environment variables template
└── apply-vscode-theme.sh # Theme application script
```

## Build Outputs

### Development
```
node_modules/            # NPM dependencies (git ignored)
.tauri/                 # Tauri build cache (git ignored)
dist/                   # Frontend build output (git ignored)
```

### Production
```
src-tauri/target/       # Rust build output
├── release/
│   ├── bundle/        # Platform installers
│   └── claudia        # Executable
└── debug/             # Debug builds
```

## Special Directories

### Claude Configuration
```
.claude/
├── settings.json       # Project settings
├── settings.local.json # Local overrides
└── CLAUDE.md          # Project context
```

### Vendor Directory
```
vendor/
├── claude-code.vsix    # VS Code extension
├── ripgrep/           # Ripgrep binaries
│   ├── arm64-darwin/
│   ├── x64-darwin/
│   ├── arm64-linux/
│   ├── x64-linux/
│   └── x64-win32/
└── yoga.wasm          # Layout engine
```

## File Naming Conventions

### TypeScript/React Files
- Components: PascalCase (e.g., `StreamMessage.tsx`)
- Utilities: camelCase (e.g., `utils.ts`)
- Types: PascalCase with `.types.ts` suffix
- Hooks: camelCase with `use` prefix (e.g., `useVirtualizer.ts`)

### Rust Files
- Modules: snake_case (e.g., `session_manager.rs`)
- Tests: module name + `_tests.rs`
- Types: snake_case for files, PascalCase for structs

## Import Structure

### Frontend Imports
```typescript
// External dependencies
import React from 'react';
import { motion } from 'framer-motion';

// Internal components
import { Button } from '@/components/ui/button';
import { StreamMessage } from '@/components/StreamMessage';

// Utilities and types
import { cn } from '@/lib/utils';
import type { Session } from '@/lib/api';
```

### Path Aliases
```json
{
  "@/": "src/",
  "@components/": "src/components/",
  "@lib/": "src/lib/"
}
```

## Best Practices

### 1. Component Organization
- One component per file
- Related components in same directory
- Shared components in `ui/` directory

### 2. State Management
- Local state in components
- Shared state via context or props
- Complex state with useReducer

### 3. File Size Guidelines
- Components: < 500 lines
- Utilities: < 200 lines
- Split large files into smaller modules

### 4. Testing Structure
- Tests mirror source structure
- Unit tests alongside source files
- Integration tests in dedicated directory

## Future Expansion

### Planned Directories
```
src/
├── plugins/            # Plugin system
├── themes/            # Theme variations
├── locales/           # Internationalization
└── workers/           # Web workers
```

### Scalability Considerations
- Modular architecture for easy extension
- Clear separation of concerns
- Consistent naming patterns
- Documentation for each module