//
//  main.m
//  HelloTriangle
//
//  Created by Konstantin Moskalenko on 04.04.2021.
//

#import <AppKit/AppKit.h>
#import "MetalView.h"

void setupWindow() {
    NSRect frame = NSMakeRect(0, 0, 400, 400);
    
    NSWindowStyleMask style =
        NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
        NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    
    NSWindow *window = [[NSWindow alloc]
                        initWithContentRect:frame styleMask:style
                        backing:NSBackingStoreBuffered defer:NO];
    [window setTitle:@"Hello, Triangle!"];
    [window makeKeyAndOrderFront:nil];
    [window setContentView:[MetalView new]];
    
    CGFloat screenHeight = window.screen.frame.size.height;
    NSPoint topLeftPoint = NSMakePoint(40, screenHeight - 68);
    [window setFrameTopLeftPoint:topLeftPoint];
    
    // Terminate the application when the user closes the window
    [[NSNotificationCenter defaultCenter]
     addObserver:NSApp selector:@selector(terminate:)
     name:NSWindowWillCloseNotification object:window];
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        
        setupWindow();
        
        [NSApp activateIgnoringOtherApps:YES];
        [NSApp run];
    }
    return 0;
}
