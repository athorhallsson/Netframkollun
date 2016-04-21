//
//  RegisterViewController.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

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

- (IBAction)registerPressed:(UIButton *)sender;
- (IBAction)backPressed:(UIButton *)sender;

@end
