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
 andWithImageItemId:(NSNumber *)itemId {
    self = [super init];
    _image = myImage;
    _imageType = type;
    _imageId = [self getUUID];
    _count = @1;
    _imageItemId = itemId;
    _imageName = @"MyPhotoName";
    return self;
}

- (NSString *)getUUID {
    return [[NSUUID UUID] UUIDString];
}

@end