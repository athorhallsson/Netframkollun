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
#import "Photo.h"
#import "ImageType.h"
#import "Delivery.h"
#import "Payment.h"


@interface OrderViewController ()
@property (strong, nonatomic) Payment *selectedPayment;
@property (strong, nonatomic) Delivery *selectedDelivery;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register segmented controls changed notifications
    [_deliveryControl addTarget:self action:@selector(deliveryChanged:) forControlEvents:UIControlEventValueChanged];
    [_paymentControl addTarget:self action:@selector(paymentChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Set defaults
    // Stadgreitt
    _selectedPayment = [_payments objectForKey:@"5"];
    // Pickup
    _selectedDelivery = [_deliveries objectForKey:@"4"];
    
    // Calculate price of the order
    _totalPrice = [NSNumber numberWithInteger:[self calculatePrice]];
    [self updatePrice];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deliveryChanged:(UISegmentedControl*)control {
    if ([control selectedSegmentIndex] == 0) {
        // Sott
        [_paymentControl setHidden:YES];
        _selectedDelivery = [_deliveries objectForKey:@"4"];
        _selectedPayment = [_payments objectForKey:@"5"];
    }
    else {
        // Sent
        _selectedDelivery = [_deliveries objectForKey:@"2"];
        [_paymentControl setHidden:NO];
    }
    [self updatePrice];
}

- (void)paymentChanged:(UISegmentedControl*)control {
    if ([control selectedSegmentIndex] == 0) {
        // Kreditkort
        _selectedPayment = [_payments objectForKey:@"3"];
    }
    else {
        // Postkrafa
        _selectedPayment = [_payments objectForKey:@"4"];
    }
    [self updatePrice];
}

- (void)updatePrice {
    [_priceLabel setText:[NSString stringWithFormat:@"%d kr.", _totalPrice.intValue + _selectedDelivery.price.intValue + _selectedPayment.price.intValue]];
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

- (NSInteger)calculatePrice {
    int totalPrice = 0;
    for (Photo *photo in _photos) {
        int currPrice = [[[_imageTypes valueForKey:photo.imageType.imageTypeId] price] intValue];
        currPrice = currPrice * [photo.count intValue];
        totalPrice = totalPrice + currPrice;
    }
    return totalPrice;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"sendSegue"]) {
         [(SendViewController*)[segue destinationViewController] setPhotos:_photos];
    }
}

@end



