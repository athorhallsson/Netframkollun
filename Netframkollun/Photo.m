//
//  Photo.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "Photo.h"
@import Foundation;

@implementation Photo

- (id)initWithImage:(UIImage *)myImage
   andWithImageType:(ImageType *)type
            andName:(NSString *)name {
    self = [super init];
    _image = myImage;
    _originalImage = myImage;
    _imageType = type;
    _imageId = [[NSUUID UUID] UUIDString];
    _count = @1;
    _imageName = name;
    return self;
}

@end