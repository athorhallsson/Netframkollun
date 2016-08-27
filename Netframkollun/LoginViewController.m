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
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// Buttons

- (IBAction)loginButtonPressed:(UIButton *)sender {
    if ([_emailTextfield.text  isEqual:@""] || [_passwordTextField.text  isEqual:@""]) {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Þú gabbar mig ekki svona auðveldlega"
                                     message:@"þú verður að slá inn netfang og lykilorð"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        [NetworkManager sendLogin:_emailTextfield.text
                     withPassword:_passwordTextField.text
                       withSender:self];
    }
}

- (void)login:(id)sender {
    [self performSegueWithIdentifier:@"LoginSuccess" sender:nil];
}

- (void)loginError:(id)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Nú ertu eitthvað að rugla"
                                 message:@"netfangið eða lykilorðið er rangt slegið inn"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action) {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
