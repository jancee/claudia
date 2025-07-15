import React, { useMemo, useEffect, useRef } from "react";
import { ChevronRight, User, Bot, FileText, Search, Edit, Code, Terminal, Globe, Hash } from "lucide-react";
import { cn } from "@/lib/utils";
import { ScrollArea } from "@/components/ui/scroll-area";
import { motion } from "framer-motion";

interface NavigationItem {
  id: string;
  type: 'user' | 'assistant';
  content: string;
  toolCalls?: Array<{
    id: string;
    type: string;
    name?: string;
  }>;
  index: number;
}

interface ConversationNavigationProps {
  messages: NavigationItem[];
  activeMessageId?: string;
  onNavigate: (messageId: string, toolCallId?: string) => void;
}

// Helper function to truncate text to 30 characters
const truncateText = (text: string, maxLength: number = 30): string => {
  if (!text) return '';
  // Remove newlines and extra spaces
  const cleanText = text.replace(/\n/g, ' ').replace(/\s+/g, ' ').trim();
  if (cleanText.length <= maxLength) return cleanText;
  return cleanText.substring(0, maxLength) + '...';
};

// Helper function to get tool icon and description
const getToolInfo = (toolType: string, toolName?: string): { icon: React.ReactNode; description: string } => {
  switch (toolType) {
    case 'read_file':
    case 'Read':
      return { icon: <FileText className="h-3 w-3" />, description: '读取文件' };
    case 'edit_file':
    case 'Edit':
      return { icon: <Edit className="h-3 w-3" />, description: '编辑文件' };
    case 'write_file':
    case 'Write':
      return { icon: <FileText className="h-3 w-3" />, description: '写入文件' };
    case 'search':
    case 'Grep':
    case 'grep':
      return { icon: <Search className="h-3 w-3" />, description: '搜索内容' };
    case 'bash':
    case 'Bash':
    case 'execute_command':
      return { icon: <Terminal className="h-3 w-3" />, description: '执行命令' };
    case 'web_search':
    case 'WebSearch':
    case 'WebFetch':
      return { icon: <Globe className="h-3 w-3" />, description: '网络搜索' };
    case 'MultiEdit':
      return { icon: <Edit className="h-3 w-3" />, description: '批量编辑' };
    case 'LS':
      return { icon: <FileText className="h-3 w-3" />, description: '列出文件' };
    case 'TodoWrite':
      return { icon: <Hash className="h-3 w-3" />, description: '更新待办事项' };
    case 'Task':
      return { icon: <Bot className="h-3 w-3" />, description: '执行任务' };
    default:
      return { icon: <Code className="h-3 w-3" />, description: toolName || toolType };
  }
};

export const ConversationNavigation: React.FC<ConversationNavigationProps> = ({
  messages,
  activeMessageId,
  onNavigate,
}) => {
  const scrollAreaRef = useRef<HTMLDivElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  
  // Process messages to create navigation structure
  const navigationItems = useMemo(() => {
    const items: Array<{
      message: NavigationItem;
      tools: Array<{ messageId: string; toolId: string; info: { icon: React.ReactNode; description: string } }>;
    }> = [];

    let currentUserItem: typeof items[0] | null = null;

    messages.forEach((message) => {
      if (message.type === 'user') {
        // Add user message as primary navigation item
        currentUserItem = {
          message,
          tools: [],
        };
        items.push(currentUserItem);
      } else if (message.type === 'assistant' && currentUserItem) {
        // Check if this assistant message has tool calls
        if (message.toolCalls && message.toolCalls.length > 0) {
          message.toolCalls.forEach((toolCall) => {
            const toolInfo = getToolInfo(toolCall.type, toolCall.name);
            currentUserItem!.tools.push({
              messageId: message.id,
              toolId: toolCall.id,
              info: toolInfo,
            });
          });
        }
        
        // Also add AI text replies
        if (message.content && message.content.trim()) {
          currentUserItem.tools.push({
            messageId: message.id,
            toolId: `text-${message.id}`,
            info: { icon: <Bot className="h-3 w-3" />, description: truncateText(message.content, 35) },
          });
        }
      }
    });

    return items;
  }, [messages]);

  // Helper function to scroll to bottom
  const scrollToBottom = () => {
    requestAnimationFrame(() => {
      setTimeout(() => {
        // Try different approaches to find the scroll container
        let scrollElement = null;
        
        // Method 1: Radix ScrollArea viewport
        scrollElement = scrollAreaRef.current?.querySelector('[data-radix-scroll-area-viewport]');
        
        // Method 2: Look for overflow auto elements
        if (!scrollElement) {
          scrollElement = scrollAreaRef.current?.querySelector('.overflow-auto');
        }
        
        // Method 3: Find element with scroll capability
        if (!scrollElement) {
          const elements = scrollAreaRef.current?.querySelectorAll('*');
          elements?.forEach((el) => {
            const style = window.getComputedStyle(el);
            if (style.overflow === 'auto' || style.overflowY === 'auto' || style.overflow === 'scroll' || style.overflowY === 'scroll') {
              scrollElement = el;
            }
          });
        }
        
        // Method 4: Fallback to container ref
        if (!scrollElement) {
          scrollElement = containerRef.current?.parentElement;
        }
        
        if (scrollElement) {
          // Smooth scroll to bottom
          scrollElement.scrollTo({
            top: scrollElement.scrollHeight,
            behavior: 'smooth'
          });
        }
      }, 150);
    });
  };

  // Auto-scroll to bottom when new messages arrive
  useEffect(() => {
    if (navigationItems.length > 0) {
      scrollToBottom();
    }
  }, [navigationItems.length]);

  // Also listen for messages changes to ensure we catch all updates
  useEffect(() => {
    if (messages.length > 0) {
      scrollToBottom();
    }
  }, [messages.length]);

  return (
    <div className="h-full flex flex-col bg-card border-r">
      <div className="px-4 py-3 border-b bg-muted/30">
        <h3 className="text-sm font-semibold flex items-center gap-2">
          <Hash className="h-3.5 w-3.5" />
          对话导航
        </h3>
      </div>
      
      <ScrollArea ref={scrollAreaRef} className="flex-1">
        <div ref={containerRef} className="py-1">
          {/* 分类标题 */}
          {navigationItems.length > 0 && (
            <div className="px-4 py-1.5 sticky top-0 bg-card z-10 border-b">
              <div className="flex items-center gap-2 text-xs text-muted-foreground">
                <span className="font-medium">用户对话</span>
                <span className="text-[10px]">({navigationItems.length})</span>
              </div>
            </div>
          )}
          
          {navigationItems.map((item, index) => (
            <div key={item.message.id} className="border-b last:border-b-0">
              {/* 一级分类：用户消息 */}
              <motion.button
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: index * 0.05 }}
                onClick={() => onNavigate(item.message.id)}
                className={cn(
                  "w-full text-left px-4 py-2 transition-all duration-200",
                  "hover:bg-accent/30 group relative",
                  activeMessageId === item.message.id && "bg-accent/50"
                )}
              >
                <div className="flex items-start gap-2">
                  <div className="flex items-center justify-center w-5 h-5 rounded-full bg-primary/10 shrink-0">
                    <User className="h-2.5 w-2.5 text-primary" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <span className="text-sm block leading-tight">
                      {truncateText(item.message.content, 45)}
                    </span>
                  </div>
                </div>
              </motion.button>

              {/* 二级分类：AI 动作 */}
              {item.tools.length > 0 && (
                <div className="bg-muted/20 py-1">
                  <div className="px-4 py-1">
                    <span className="text-[10px] font-medium text-muted-foreground uppercase tracking-wider">AI 执行动作</span>
                  </div>
                  <div className="">
                    {item.tools.map((tool, toolIndex) => (
                      <motion.button
                        key={`${tool.messageId}-${tool.toolId}`}
                        initial={{ opacity: 0, x: -10 }}
                        animate={{ opacity: 1, x: 0 }}
                        transition={{ delay: index * 0.05 + (toolIndex + 1) * 0.02 }}
                        onClick={() => onNavigate(tool.messageId, tool.toolId)}
                        className={cn(
                          "w-full text-left px-4 py-1 transition-all duration-200",
                          "hover:bg-background/50 text-muted-foreground hover:text-foreground",
                          "flex items-center gap-2 text-xs group"
                        )}
                      >
                        <ChevronRight className="h-2.5 w-2.5 opacity-40 group-hover:opacity-100 transition-opacity shrink-0" />
                        <div className="flex items-center justify-center w-4 h-4 rounded bg-background/30 shrink-0">
                          {React.cloneElement(tool.info.icon as React.ReactElement, { className: "h-2.5 w-2.5" })}
                        </div>
                        <span className="truncate leading-tight">
                          {truncateText(tool.info.description, 35)}
                        </span>
                      </motion.button>
                    ))}
                  </div>
                </div>
              )}
            </div>
          ))}
          
          {navigationItems.length === 0 && (
            <div className="px-4 py-8 text-center text-sm text-muted-foreground">
              暂无对话内容
            </div>
          )}
        </div>
      </ScrollArea>
    </div>
  );
};