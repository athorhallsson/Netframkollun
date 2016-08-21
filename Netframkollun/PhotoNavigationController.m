//
//  PhotoNavigationController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 10/08/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PhotoNavigationController.h"

@interface PhotoNavigationController ()

@end

@implementation PhotoNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [(PhotoDetailsViewController *)self.topViewController setDetailPhoto:_detailPhoto];
    [(PhotoDetailsViewController *)self.topViewController setSizePickerData:_sizePickerData];
}


@end
