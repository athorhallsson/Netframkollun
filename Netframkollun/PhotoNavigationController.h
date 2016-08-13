//
//  PhotoNavigationController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 10/08/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "PhotoDetailsViewController.h"

@interface PhotoNavigationController : UINavigationController

@property (strong, nonatomic) Photo *detailPhoto;
@property (strong, nonatomic) NSDictionary *sizePickerData;

@end
