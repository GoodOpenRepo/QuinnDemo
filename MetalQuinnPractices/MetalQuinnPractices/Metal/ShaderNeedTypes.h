//
//  ShaderNeedTypes.h
//  MetalQuinnPractices
//
//  Created by Quinn on 2018/11/7.
//  Copyright © 2018 Quinn. All rights reserved.
//

#ifndef ShaderNeedTypes_h
#define ShaderNeedTypes_h
#include <simd/simd.h>
//如果报错先编译一下
typedef struct{
    vector_float2 position;
    vector_float4 color;
}PositionColor;

typedef struct{
    vector_float2 position;
    vector_float2 texture;
}PositionTexture;
#endif /* ShaderNeedTypes_h */
