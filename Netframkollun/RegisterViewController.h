//
//  RegisterViewController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"
#import "User.h"
#import "PhotoViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController : UIViewController <UITextFieldDelegate, NSXMLParserDelegate, UIPickerViewDelegate, UIPickerViewDataSource, LoginInterface>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ssnTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *postalTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;

@property (weak, nonatomic) UITextField *activeField;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSData *webResponseData;

@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *pCodes;

@property (strong, nonatomic) NSString *tempLocation;
@property (nonatomic) BOOL inLocation;
@property (nonatomic) BOOL inPostCode;

- (IBAction)registerPressed:(UIButton *)sender;
- (IBAction)backPressed:(UIButton *)sender;

- (void)login:(id)sender;

- (void)loginError:(id)sender;

@end
