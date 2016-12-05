//
//  UIImage+Extension.m
//  测试毛玻璃效果
//
//  Created by ibokan on 15/11/17.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/**
 *  设置图片模糊度
 *
 *  @param radius 模糊程度大小（数值越大越模糊）
 *  @param image  原始图片
 *
 *  @return 返回模糊后的图片
 */
+ (UIImage *)imageApplyBlurRadius:(CGFloat)radius toImage:(UIImage *)image {
    if (radius < 0) radius = 0;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return returnImage;
}

//对图片尺寸进行压缩--

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    // End the context
    
    UIGraphicsEndImageContext();
    
    
    
    // Return the new image.
    
    return newImage;
    
}

@end





