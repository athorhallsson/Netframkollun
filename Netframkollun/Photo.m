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
   andWithImageType:(ImageType *)type
 andWithImageItemId:(NSNumber *)itemId {
    self = [super init];
    _image = myImage;
    _imageType = type;
    _imageId = [self getUUID];
    _count = @1;
    _imageItemId = itemId;
    return self;
}

- (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end