//
//  MetalView.m
//  HelloTriangle
//
//  Created by Konstantin Moskalenko on 06.04.2021.
//

#import "MetalView.h"
#import "Renderer.h"

@implementation MetalView {
    Renderer *_renderer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.device = MTLCreateSystemDefaultDevice();
        NSAssert(self.device, @"Metal is not supported on this device");
        
        _renderer = [[Renderer alloc] initWithMetalKitView:self];
        NSAssert(_renderer, @"Renderer failed initialization");
        
        self.delegate = _renderer;
    }
    return self;
}

// MARK: - Handling Events

- (void)mouseDown:(NSEvent *)event {
    
}

- (void)mouseDragged:(NSEvent *)event {
    
}

@end
