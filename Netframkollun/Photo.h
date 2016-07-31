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

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) ImageType *imageType;
@property (nonatomic, strong) NSNumber* count;

- (id)initWithImage:(UIImage *)myImage andWithImageType:(ImageType *)type;

@end
