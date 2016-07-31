//
//  Photo.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageType.h"

@interface Photo : NSObject

@property (nonatomic, strong) NSNumber* imageItemId;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ImageType *imageType;
@property (nonatomic, strong) NSNumber* count;
@property (nonatomic, strong) NSString* imageId;
@property (nonatomic, strong) NSString* imageName;

- (id)initWithImage:(UIImage *)myImage andWithImageType:(ImageType *)type andWithImageItemId:(NSNumber *)itemId;

- (NSString *)getUUID;

@end
