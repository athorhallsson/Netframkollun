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

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) NSMutableArray *photos;

@property (strong, nonatomic) Delivery *delivery;
@property (strong, nonatomic) Payment *payment;
@property (strong, nonatomic) NSString *orderId;
@property (nonatomic) NSInteger uploadedCount;
@property (nonatomic) NSString *comments;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


- (void) displaySuccess:(NSString *)message;
- (void) updateProgress;

@end
