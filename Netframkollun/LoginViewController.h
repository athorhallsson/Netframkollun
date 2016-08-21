//
//  LoginViewController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"
#import "User.h"
#import "PhotoViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

@property (strong, nonatomic) NSString *parseString;
@property (strong, nonatomic) NSString *errorCode;

- (IBAction)loginButtonPressed:(UIButton *)sender;

- (void)loginError:(id)sender;
- (void)login:(id)sender;

@end
