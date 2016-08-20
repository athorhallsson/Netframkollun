//
//  SendViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "SendViewController.h"
#import "Properties.h"
#import "SessionManager.h"
#import "User.h"
#import "NetworkManager.h"

@interface SendViewController ()
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_activityIndicator startAnimating];
    User *currUser = [SessionManager getSignedInUser];
    [NetworkManager createOrder:currUser withPayment:_payment withDelivery:_delivery withPhotos:_photos withComment:_comments withSender:self];
    // So it can be incremented once
    _uploadedCount = -1;
    [self updateProgress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateProgress {
    _uploadedCount++;
    [_progressLabel setText:[NSString stringWithFormat:@"%ld / %ld", (long)_uploadedCount, (long)[_photos count]]];
    if (_uploadedCount == [_photos count]) {
        [NetworkManager finalizeOrderwithSender:self];
    }
}

- (void) displaySuccess:(NSString *)message {
    [_activityIndicator setHidesWhenStopped:true];
    [_activityIndicator stopAnimating];
    [_headingLabel setText:@"Takk fyrir"];
    [_messageLabel setText:message];
}

@end
