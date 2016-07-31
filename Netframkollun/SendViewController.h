//
//  SendViewController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Delivery.h"
#import "Payment.h"
#import "Photo.h"
#import "CreateOrderResponseParser.h"

@interface SendViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSMutableArray *photos;

@property (strong, nonatomic) User *currUser;

@property (strong, nonatomic) Delivery *delivery;

@property (strong, nonatomic) Payment *payment;

@property (strong, nonatomic) NSString *orderId;

@end
