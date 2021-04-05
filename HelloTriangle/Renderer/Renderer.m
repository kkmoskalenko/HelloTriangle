//
//  Renderer.m
//  HelloTriangle
//
//  Created by Konstantin Moskalenko on 05.04.2021.
//

#import <simd/vector_types.h>
#import "Renderer.h"

@implementation Renderer {
    id<MTLDevice> _device;
    id<MTLRenderPipelineState> _pipelineState;
    id<MTLCommandQueue> _commandQueue;
    vector_uint2 _viewportSize;
}

- (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView {
    self = [super init];
    if (self) {
        _device = mtkView.device;
        
        // Load all the shader files with a .metal file extension in the project
        id<MTLLibrary> defaultLibrary = [_device newDefaultLibrary];
        
        // Configure a pipeline descriptor that is used to create a pipeline state
        MTLRenderPipelineDescriptor *pipelineStateDescriptor = [MTLRenderPipelineDescriptor new];
        pipelineStateDescriptor.vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
        pipelineStateDescriptor.fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;
        
        NSError *error;
        _pipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
        NSAssert(_pipelineState, @"Failed to create pipeline state: %@", error);
        
        // Create the command queue
        _commandQueue = [_device newCommandQueue];
    }
    
    return self;
}

/// Called whenever the view needs to render a frame.
- (void)drawInMTKView:(nonnull MTKView *)view {
    static const vector_float2 triangleVertices[] = {
        { 250, -250 }, { -250, -250 }, { 0, 250 }
    };
    
    // Create a new command buffer for each render pass to the current drawable
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    // Obtain a renderPassDescriptor generated from the view's drawable textures
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    if (renderPassDescriptor != nil) {
        // Color #25854b == rgba(37, 133, 75, 1)
        renderPassDescriptor.colorAttachments[0].clearColor =
        MTLClearColorMake(37/255.0, 133/255.0, 75/255.0, 1);
        
        // Configure a render command encoder
        id<MTLRenderCommandEncoder> renderEncoder =
        [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, 0.0, 1.0 }];
        [renderEncoder setRenderPipelineState:_pipelineState];
        [renderEncoder setVertexBytes:triangleVertices length:sizeof(triangleVertices) atIndex:0];
        [renderEncoder setVertexBytes:&_viewportSize length:sizeof(_viewportSize) atIndex:1];
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
        [renderEncoder endEncoding];
        
        // Schedule a present once the framebuffer is complete using the current drawable
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    // Finalize rendering here & push the command buffer to the GPU
    [commandBuffer commit];
}

/// Called whenever view changes orientation or is resized
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    // Save the size of the drawable to pass to the vertex shader
    _viewportSize.x = size.width;
    _viewportSize.y = size.height;
}

@end
