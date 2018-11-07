//
//  Shader.metal
//  MetalQuinnPractices
//
//  Created by Quinn on 2018/11/7.
//  Copyright © 2018 Quinn. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
#import "ShaderNeedTypes.h"

typedef struct
{
    float4 position [[position]];
    float4 color;
} VertexData;

///纯色

vertex VertexData vertexShader(constant PositionColor * positionColors [[buffer(0)]],uint vertrxID [[vertex_id]]){
    VertexData outVertexData;
    outVertexData.position = vector_float4(positionColors[vertrxID].position,0,1);
    outVertexData.color = positionColors[vertrxID].color;
    return outVertexData;
}

fragment float4 fragmentShader(VertexData inVertex [[stage_in]]){
    return inVertex.color;
}

///纹理
typedef struct
{
    float4 position [[position]];
    float2 texture;
} TextureVertexData;
vertex TextureVertexData vertexShaderTexture(constant PositionTexture * positionTexture [[buffer(0)]],uint vertrxID [[vertex_id]]){
    TextureVertexData outVertexData;
    outVertexData.position = vector_float4(positionTexture[vertrxID].position,0,1);
    outVertexData.texture = positionTexture[vertrxID].texture;
    return outVertexData;
}

fragment float4 fragmentShaderTexture(TextureVertexData inVertex [[stage_in]],
                                     texture2d<float> tex2d [[texture(0)]]){
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    return float4(tex2d.sample(textureSampler, inVertex.texture));
}
