# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

PRD目录包含了你对这个工程的产品需求和技术架构设计的记忆，你需要首先了解这里边的内容，并且随着你与用户的沟通，每次对话后，如果有发生变更，更新里边的记忆；注意，记忆不是按照时间线、更新时间节点记录的，而是完整对工程的描述

## Project Overview

Claudia is a desktop GUI application for Claude Code built with Tauri 2 (Rust backend) and React (TypeScript frontend). It provides visual project management, custom AI agents, usage analytics, and session timeline features for Claude Code users.

## Essential Commands

```bash
# Development
bun install                      # Install dependencies
bun run tauri dev               # Start dev server with hot reload

# Build
bun run tauri build             # Build production app
bun run tauri build --debug     # Debug build
bun run tauri build --target universal-apple-darwin  # macOS universal binary

# Claude Code Executables
bun run build:executables       # Build for all platforms
bun run build:executables:current  # Build for current platform only

# Testing (Rust backend)
cd src-tauri && cargo test      # Run all tests
cd src-tauri && cargo test -- --test-threads=1  # Run tests sequentially
```

注意，除非用户明确对你要求，你不能自己尝试运行项目

## Architecture

### Frontend (React/TypeScript)
- **Entry**: `src/main.tsx`
- **Routing**: `src/App.tsx` manages view state
- **Key Views**:
  - `ClaudeCodeSession`: Main chat interface with Claude
  - `CCAgents`: Agent creation and management
  - `ProjectList`/`SessionList`: Project browsing
  - `UsageDashboard`: Token usage analytics

### Backend (Rust/Tauri)
- **Commands** (`src-tauri/src/commands/`):
  - `agents.rs`: Agent CRUD operations
  - `claude.rs`: Claude CLI process management
  - `storage.rs`: Project/session data access
  - `usage.rs`: Usage statistics
- **Process Registry** (`src-tauri/src/process/`): Manages running Claude instances
- **Checkpoint System** (`src-tauri/src/checkpoint/`): Session versioning/branching

### Key Architectural Patterns

1. **Tauri Command Pattern**: Frontend calls Rust commands via `@tauri-apps/api`
   ```typescript
   // Frontend
   await invoke('execute_agent', { agentId, projectPath, task })
   
   // Backend
   #[tauri::command]
   async fn execute_agent(agent_id: String, ...) -> Result<ProcessId>
   ```

2. **Process Management**: Each Claude/agent session runs as a separate process tracked by ProcessRegistry
   - Prevents UI blocking
   - Allows cancellation
   - Tracks multiple concurrent sessions

3. **Event Streaming**: Real-time output from Claude via Tauri events
   ```rust
   app_handle.emit("claude-stream", payload)
   ```

4. **Data Storage**:
   - SQLite for agents, usage tracking
   - File system for sessions/checkpoints (`~/.claude/`)
   - JSON serialization for data exchange

## Claude Code Integration

The app downloads and builds Claude Code CLI from npm:
1. `scripts/fetch-and-build.js` fetches the npm package
2. Embeds required assets (yoga.wasm, ripgrep binaries)
3. Creates platform-specific executables in `src-tauri/binaries/`
4. Tauri uses these as "sidecar" binaries

## Custom UI Modifications

Recent modifications include:
- VS Code dark theme (see `apply-vscode-theme.sh`)
- Full-width chat layout
- Conversation navigation sidebar (384px width)
- Custom scrollbar styling
- Custom VS Code-style title bar replacing native macOS title bar
  - Custom window controls (minimize, maximize, close)
  - Draggable title bar region using data-tauri-drag-region
  - macOS private API enabled for proper window behavior

## Development Tips

1. **Hot Reload**: Frontend changes reload instantly, backend changes require restart
2. **Console Logs**: Use browser DevTools for frontend, terminal for Rust logs
3. **State Management**: Most state is in React components, complex state uses contexts
4. **Error Handling**: Rust commands return `Result<T>`, frontend handles via try/catch

## Key Files to Understand

- `src-tauri/tauri.conf.json`: App configuration, permissions, build settings
- `src/lib/api.ts`: Frontend API client for all backend commands
- `src/components/StreamMessage.tsx`: Renders Claude's streaming responses
- `src/components/CustomTitleBar.tsx`: Custom VS Code-style title bar component
- `src/components/ConversationNavigation.tsx`: Sidebar navigation for conversations
- `src-tauri/src/process/registry.rs`: Core process management logic