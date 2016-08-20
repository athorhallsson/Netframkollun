//
//  LoginViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "LoginViewController.h"
#import "SessionManager.h"
#import "NetworkManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize user
    _currUser = [[User alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Buttons

- (IBAction)loginButtonPressed:(UIButton *)sender {
    if ([_emailTextfield.text  isEqual:@""] || [_passwordTextField.text  isEqual:@""]) {
        return;
    }
    [NetworkManager sendLogin:_emailTextfield.text
                 withPassword:_passwordTextField.text
                   withSender:self];
}

- (void)login:(id)sender {
    [self performSegueWithIdentifier:@"LoginSuccess" sender:nil];
}

- (void)loginError:(id)sender {
    [_emailTextfield setBackgroundColor:[UIColor colorWithRed:0.95 green:0.5 blue:0.4 alpha:1.0]];
    [_passwordTextField setBackgroundColor:[UIColor colorWithRed:0.95 green:0.5 blue:0.4 alpha:1.0]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"LoginSuccess"]) {
//        [(PhotoViewController*)[segue destinationViewController] setCurrUser:_currUser];
//    }
}

@end
