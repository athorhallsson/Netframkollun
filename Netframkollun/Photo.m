//
//  Photo.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (id)initWithImage:(UIImage *)myImage {
    self = [super init];
    _image = myImage;
    _imageSize = @"10x15";
    _count = 1;
    return self;
}

@end