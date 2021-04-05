//
//  Shaders.metal
//  HelloTriangle
//
//  Created by Konstantin Moskalenko on 05.04.2021.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 vertexShader(
    uint vertexID [[vertex_id]],
    constant vector_float2 *vertices [[buffer(0)]],
    constant vector_uint2 *viewportSizePointer [[buffer(1)]]
) {
    float4 out;

    // The positions are specified in pixel dimensions
    float2 pixelSpacePosition = vertices[vertexID].xy;

    // Get the viewport size and cast to float
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);

    // To convert from positions in pixel space to positions in clip-space,
    // divide the pixel coordinates by half the size of the viewport
    out = vector_float4(0.0, 0.0, 0.0, 1.0);
    out.xy = pixelSpacePosition / (viewportSize / 2.0);

    return out;
}

fragment float4 fragmentShader() {
    // Return white color
    return 1.0;
}
