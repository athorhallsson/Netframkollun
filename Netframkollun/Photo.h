//
//  Photo.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 19/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic, retain) UIImage *image;

@property (copy) NSString *imageSize;

@property NSInteger count;

- (id)initWithImage:(UIImage *)myImage;

@end
