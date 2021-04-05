//
//  Renderer.h
//  HelloTriangle
//
//  Created by Konstantin Moskalenko on 05.04.2021.
//

#import <MetalKit/MetalKit.h>

@interface Renderer : NSObject<MTKViewDelegate>

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;

@end
