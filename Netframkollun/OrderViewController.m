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
    
    // Register segmented controls changed notifications
    [_deliveryControl addTarget:self action:@selector(deliveryChanged:) forControlEvents:UIControlEventValueChanged];
    [_paymentControl addTarget:self action:@selector(paymentChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Calculate price of the order
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
    }
    else {
        [_paymentControl setHidden:NO];
    }
    [self updatePrice];
}

- (void)paymentChanged:(UISegmentedControl*)control {
    [self updatePrice];
}

- (void)updatePrice {
    int displayPrice = (int)_totalPrice.integerValue;
    if ([_deliveryControl selectedSegmentIndex] != 0) {
        displayPrice += 990;
        if ([_paymentControl selectedSegmentIndex] == 1) {
            displayPrice += 300;
        }
    }
    
    [_priceLabel setText:[NSString stringWithFormat:@"%d kr.", displayPrice]];
}

- (IBAction)sendButtonPressed:(UIButton *)sender {
    // Assemble all information about the order and pass it along
    [self performSegueWithIdentifier:@"sendSegue" sender:_photos];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sendSegue"]) {
         [(SendViewController*)[segue destinationViewController] setPhotos:_photos];
    }
}

@end



