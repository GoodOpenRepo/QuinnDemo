//
//  RadialGradientView.m
//  MaskViewDemo
//
//  Created by Quinn on 2018/12/29.
//  Copyright © 2018 Quinn. All rights reserved.
//

#import "RadialGradientView.h"

@implementation RadialGradientView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.type == GradientTypeNone) {
        return;
    }
    CGContextRef context=UIGraphicsGetCurrentContext();
    if (self.type == GradientTypeLinear) {
        [self drawLinearGradient:context];
    }else if(self.type == GradientTypeCircle) {
        [self drawRadialGradient:context];
    }
}

#pragma mark - 线性渐变
-(void)drawLinearGradient:(CGContextRef)context{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //rgb 颜色空间
    // space 颜色空间 ; compoents rgb颜色色值, 四个数组元素表示一个颜色（red、green、blue、alpha）;locations 颜色渐变的区域 0~0.3有第一种颜色渐变为第二种颜色 0.3~1.0由第二种颜色渐变为白色;count 为渐变的个数
    CGFloat compoents[12] = {248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0}; //数组可以这样写 好流弊
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    /*绘制
     context:图形上下文
     gradient:渐变色
     startPoint:起始位置
     endPoint:终止位置
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
     */
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(320, 50), kCGGradientDrawsAfterEndLocation);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}

#pragma mark 径向渐变
-(void)drawRadialGradient:(CGContextRef)context{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); //rgb 颜色空间
    // space 颜色空间 ; compoents rgb颜色色值, 四个数组元素表示一个颜色（red、green、blue、alpha）;locations 颜色渐变的区域 0~0.3有第一种颜色渐变为第二种颜色 0.3~1.0由第二种颜色渐变为白色;count 为渐变的个数
    CGFloat compoents[12] = {248.0/255.0,86.0/255.0,86.0/255.0,0,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,0}; //数组可以这样写 好流弊
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置  这个起始点是比较坑的地方  这个点是相对于self的位置  frame:{{112.5, 258.5}, {150, 150}}  那么这个点就是(75,75)了
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    CGContextDrawRadialGradient(context, gradient, CGPointMake(75, 75),0, CGPointMake(75, 75), 75, kCGGradientDrawsAfterEndLocation);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
}



@end
