//
//  OrderViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "OrderViewController.h"
#import "SendViewController.h"
#import "Properties.h"


@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_deliveryControl addTarget:self action:@selector(deliveryChanged:) forControlEvents:UIControlEventValueChanged];
    [_paymentControl addTarget:self action:@selector(paymentChanged:) forControlEvents:UIControlEventValueChanged];
    _totalPrice = [Properties prices:_photos];
    
    [_priceLabel setText:[NSString stringWithFormat:@"%ld kr.", (long)[_totalPrice integerValue]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deliveryChanged:(UISegmentedControl*)control {
    if ([control selectedSegmentIndex] == 0) {
        [_paymentControl setHidden:YES];
        [_priceLabel setText:[NSString stringWithFormat:@"%ld kr.", (long)_totalPrice.integerValue]];
    }
    else {
        [_paymentControl setHidden:NO];
        [_priceLabel setText:[NSString stringWithFormat:@"%ld kr.", (long)_totalPrice.integerValue + (long)990]];
    }
}

- (void)paymentChanged:(UISegmentedControl*)control {
    
}

- (IBAction)sendButtonPressed:(UIButton *)sender {
    // Assemble all information about the order and pass it along
    [self performSegueWithIdentifier:@"sendSegue" sender:_photos];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sendSegue"]) {
         [(SendViewController*)[segue destinationViewController] setPhotos:_photos];
    }
}

@end



