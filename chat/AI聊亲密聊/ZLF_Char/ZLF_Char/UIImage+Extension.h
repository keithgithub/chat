//
//  UIImage+Extension.h
//  测试毛玻璃效果
//
//  Created by ibokan on 15/11/17.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  设置图片模糊度
 *
 *  @param radius 模糊程度大小（数值越大越模糊）数值一般1~10
 *  @param image  原始图片
 *
 *  @return 返回模糊后的图片
 */
+ (UIImage *)imageApplyBlurRadius:(CGFloat)radius toImage:(UIImage *)image;

//对图片尺寸进行压缩--
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
