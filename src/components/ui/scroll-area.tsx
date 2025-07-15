import * as React from "react";
import { cn } from "@/lib/utils";

interface ScrollAreaProps extends React.HTMLAttributes<HTMLDivElement> {
  /**
   * Optional className for styling
   */
  className?: string;
  /**
   * Children to render inside the scroll area
   */
  children: React.ReactNode;
}

/**
 * ScrollArea component for scrollable content with custom scrollbar styling
 * 
 * @example
 * <ScrollArea className="h-[200px]">
 *   <div>Scrollable content here</div>
 * </ScrollArea>
 */
export const ScrollArea = React.forwardRef<HTMLDivElement, ScrollAreaProps>(
  ({ className, children, ...props }, ref) => {
    return (
      <div
        ref={ref}
        className={cn(
          "relative overflow-auto",
          // Custom scrollbar styling - wider for better visibility
          "scrollbar-auto scrollbar-thumb-border scrollbar-track-transparent",
          "[&::-webkit-scrollbar]:w-3",
          "[&::-webkit-scrollbar-track]:bg-transparent",
          "[&::-webkit-scrollbar-thumb]:bg-[rgba(66,66,66,0.8)] [&::-webkit-scrollbar-thumb]:rounded-[5px]",
          "[&::-webkit-scrollbar-thumb:hover]:bg-[rgba(78,78,78,0.8)]",
          className
        )}
        {...props}
      >
        {children}
      </div>
    );
  }
);

ScrollArea.displayName = "ScrollArea"; 