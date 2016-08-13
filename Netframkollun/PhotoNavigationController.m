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
    // Do any additional setup after loading the view.
    [(PhotoDetailsViewController *)self.topViewController setDetailPhoto:_detailPhoto];
    [(PhotoDetailsViewController *)self.topViewController setSizePickerData:_sizePickerData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
