//
//  Photo.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (id)initWithImage:(UIImage *)myImage
   andWithImageType:(ImageType *)type {
    self = [super init];
    _image = myImage;
    _imageType = type;
    _count = @1;
    return self;
}

@end