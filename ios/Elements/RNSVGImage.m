/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RNSVGImage.h"
#import "RCTConvert+RNSVG.h"
#import <React/RCTImageSource.h>
#import <React/RCTLog.h>
#import "RNSVGViewBox.h"

@implementation RNSVGImage
{
    CGImageRef _image;
    CGFloat _imageRatio;
}

- (void)setSrc:(id)src
{
    if (src == _src) {
        return;
    }
    _src = src;
    CGImageRelease(_image);
    RCTImageSource *source = [RCTConvert RCTImageSource:src];
    _imageRatio = source.size.width / source.size.height;
    _image = CGImageRetain([RCTConvert CGImage:src]);
    [self invalidate];
}

- (void)setX:(NSString *)x
{
    if (x == _x) {
        return;
    }
    [self invalidate];
    _x = x;
}

- (void)setY:(NSString *)y
{
    if (y == _y) {
        return;
    }
    [self invalidate];
    _y = y;
}

- (void)setWidth:(NSString *)width
{
    if (width == _width) {
        return;
    }
    [self invalidate];
    _width = width;
}

- (void)setHeight:(NSString *)height
{
    if (height == _height) {
        return;
    }
    [self invalidate];
    _height = height;
}

- (void)setAlign:(NSString *)align
{
    if (align == _align) {
        return;
    }
    [self invalidate];
    _align = align;
}

- (void)setMeetOrSlice:(RNSVGVBMOS)meetOrSlice
{
    if (meetOrSlice == _meetOrSlice) {
        return;
    }
    [self invalidate];
    _meetOrSlice = meetOrSlice;
}

- (void)dealloc
{
    CGImageRelease(_image);
}

- (void)renderLayerTo:(CGContextRef)context
{
    CGRect rect = [self getRect:context];

    // add hit area
    CGPathRef hitArea = CGPathCreateWithRect(rect, nil);
    [self setHitArea:hitArea];
    CGPathRelease(hitArea);
    
    CGContextSaveGState(context);

    [self clip:context];
    CGContextClipToRect(context, rect);
 
    CGContextDrawImage(context, rect, _image);
    CGContextRestoreGState(context);
}

- (CGRect)getRect:(CGContextRef)context
{
    return CGRectMake([self relativeOnWidth:self.x],
                      [self relativeOnHeight:self.y],
                      [self relativeOnWidth:self.width],
                      [self relativeOnHeight:self.height]);
}

- (CGPathRef)getPath:(CGContextRef)context
{
    return (CGPathRef)CFAutorelease(CGPathCreateWithRect([self getRect:context], nil));
}

@end
