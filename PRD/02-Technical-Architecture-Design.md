# Technical Architecture Design

## Overview

Claudia is built using modern web technologies with a Rust backend (Tauri 2) and React frontend, providing a secure, performant desktop application for managing Claude Code sessions.

## Technology Stack

### Frontend
- **Framework**: React 18 with TypeScript
- **Build Tool**: Vite 6
- **Package Manager**: Bun (high-performance JavaScript runtime)
- **UI Framework**: Tailwind CSS v4 with custom configuration
- **Component Library**: shadcn/ui (Radix UI primitives)
- **State Management**: React hooks (useState, useContext, useReducer)
- **Routing**: React Router v6
- **Animations**: Framer Motion
- **Virtual Scrolling**: @tanstack/react-virtual

### Backend
- **Framework**: Tauri 2.0 (Rust-based)
- **Language**: Rust
- **Database**: SQLite via rusqlite
- **Process Management**: tokio async runtime
- **IPC**: Tauri command system with type-safe bindings

### Development Tools
- **Type Checking**: TypeScript strict mode
- **Code Formatting**: Prettier + Rust fmt
- **Testing**: Rust unit tests + integration tests
- **Build System**: Cargo + Bun scripts

## Architecture Patterns

### 1. Component Architecture

```
src/
├── components/
│   ├── ClaudeCodeSession.tsx    # Main session component
│   ├── ConversationNavigation.tsx # Navigation sidebar
│   ├── StreamMessage.tsx         # Message display
│   ├── ToolWidgets.tsx          # Tool output widgets
│   └── ui/                      # Reusable UI components
├── lib/
│   ├── api.ts                   # Tauri command bindings
│   └── utils.ts                 # Utility functions
└── hooks/
    └── useVirtualizer.ts        # Custom hooks
```

### 2. State Management Pattern

```typescript
// Centralized state with clear data flow
interface SessionState {
  messages: ClaudeStreamMessage[];
  navigationMessages: NavigationItem[];
  isLoading: boolean;
  error: string | null;
}

// Derived state using useMemo
const displayableMessages = useMemo(() => 
  filterMessages(messages), [messages]);

const navigationMessages = useMemo(() => 
  prepareNavigation(displayableMessages), [displayableMessages]);
```

### 3. Message Processing Pipeline

```
Raw JSONL → Parse → Filter → Display → Navigate
    ↓         ↓        ↓        ↓         ↓
  Stream   Message  Displayable  UI    Sidebar
  Handler   Type    Messages   Render  Update
```

### 4. Component Communication

```
ClaudeCodeSession (Parent)
    ├── ConversationNavigation
    │   └── Receives: messages, activeId, onNavigate
    ├── StreamMessage
    │   └── Receives: message, streamMessages
    └── VirtualScroller
        └── Manages: efficient rendering
```

## Key Design Decisions

### 1. Virtual Scrolling
- **Problem**: Long conversations with thousands of messages
- **Solution**: @tanstack/react-virtual for windowed rendering
- **Benefits**: 
  - Constant memory usage
  - 60fps scrolling performance
  - Instant navigation

### 2. Message ID Generation
- **Pattern**: `msg-${timestamp}-${randomString}`
- **Purpose**: Unique identifiers for navigation
- **Implementation**:
```typescript
if (!message.id) {
  message.id = `msg-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
}
```

### 3. Theme System
- **CSS Variables**: Dynamic theme switching capability
- **OKLCH Color Space**: Originally used for precise color control
- **VS Code Theme**: Hex colors for exact match
```css
:root {
  --color-background: #1e1e1e;
  --color-foreground: #d4d4d4;
  --color-card: #252526;
}
```

### 4. Navigation Architecture
- **Two-level Hierarchy**:
  - User messages as primary categories
  - AI tool calls as secondary items
- **Efficient Updates**: Memoized computation
- **Smooth Scrolling**: Browser-native smooth behavior

## Performance Optimizations

### 1. Memoization Strategy
```typescript
// Expensive computations cached
const navigationMessages = useMemo(() => {
  // Process only when displayableMessages change
  return processMessages(displayableMessages);
}, [displayableMessages]);
```

### 2. Event Listener Management
```typescript
// Cleanup pattern for preventing memory leaks
useEffect(() => {
  const listeners = setupListeners();
  return () => listeners.forEach(unlisten => unlisten());
}, []);
```

### 3. Conditional Rendering
```typescript
// Skip unnecessary renders
if (!message.content || message.isMeta) return null;
```

## Security Considerations

### 1. Process Isolation
- Each Claude Code session runs in separate process
- Tauri provides secure IPC boundaries
- No direct file system access from frontend

### 2. Content Sanitization
- User input validated before processing
- Command injection prevention in backend
- XSS protection in React rendering

### 3. Permission Model
- Scoped file system access
- Explicit user consent for operations
- Audit logging for sensitive actions

## Data Flow

### 1. Session Initialization
```
User Action → Frontend Command → Tauri Backend → Claude CLI
     ↓              ↓                 ↓              ↓
  UI Event    API Call         Rust Handler   Process Spawn
```

### 2. Message Streaming
```
Claude Output → JSONL Stream → Event Emitter → Frontend Listener
       ↓             ↓              ↓                ↓
   stdout      Line Parser    Tauri Events    React State
```

### 3. Navigation Interaction
```
Click Nav Item → Find Message → Calculate Index → Scroll Virtual
       ↓              ↓               ↓                ↓
   onNavigate    Message ID      Array Index    scrollToIndex
```

## Testing Strategy

### 1. Unit Tests
- Component isolation with React Testing Library
- Rust backend logic tests
- Utility function coverage

### 2. Integration Tests
- Full session lifecycle tests
- Message processing pipeline
- Navigation functionality

### 3. E2E Tests
- User workflows with Playwright
- Cross-platform verification
- Performance benchmarks

## Deployment Architecture

### 1. Build Process
```bash
Frontend Build → Bundle Assets → Compile Rust → Package App
      ↓              ↓               ↓             ↓
  Vite/Bun      Embedded      Cargo Build    Tauri Bundle
```

### 2. Distribution
- Platform-specific installers (MSI, DMG, DEB)
- Auto-update mechanism via Tauri
- Code signing for security

## Monitoring and Debugging

### 1. Logging Strategy
- Structured logging with context
- Debug mode for development
- Performance metrics collection

### 2. Error Boundaries
```typescript
<ErrorBoundary fallback={<ErrorDisplay />}>
  <StreamMessage />
</ErrorBoundary>
```

### 3. Development Tools
- React DevTools integration
- Tauri DevTools for IPC debugging
- Source maps for production debugging

## Future Architecture Considerations

### 1. Plugin System
- Extensible tool widgets
- Custom navigation providers
- Theme marketplace

### 2. Collaborative Features
- WebRTC for real-time sharing
- Operational transformation for conflicts
- Presence indicators

### 3. Cloud Sync
- End-to-end encrypted backup
- Cross-device session continuity
- Selective sync policies