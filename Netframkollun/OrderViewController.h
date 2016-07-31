//
//  OrderViewController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController <UITextFieldDelegate>
NS_ASSUME_NONNULL_BEGIN

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *deliveryControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paymentControl;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSDictionary *deliveries;
@property (strong, nonatomic) NSDictionary *imageTypes;
@property (strong, nonnull) NSNumber *totalPrice;

- (IBAction)sendButtonPressed:(UIButton *)sender;
- (IBAction)backButtonPressed:(UIButton *)sender;

NS_ASSUME_NONNULL_END
@end
