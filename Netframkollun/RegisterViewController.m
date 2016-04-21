//
//  RegisterViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_ssnTextField addTarget:self
                  action:@selector(ssnTextFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    [_phoneTextField addTarget:self
                      action:@selector(phoneTextFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    [_postalTextField addTarget:self
                        action:@selector(postalTextFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerPressed:(UIButton *)sender {
    if ([self validateInput]) {
        [self performSegueWithIdentifier:@"registerSuccess" sender:nil];
    }
}

- (IBAction)backPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ssnTextFieldDidChange:(UITextField *)TextField {
    if ([[TextField text] isEqualToString:@""] || [[TextField text] length] == 10) {
        [[self view] endEditing:YES];
    }
}

- (void)postalTextFieldDidChange:(UITextField *)TextField {
    if ([[TextField text] isEqualToString:@""] || [[TextField text] length] == 3) {
        [[self view] endEditing:YES];
    }
}

- (void)phoneTextFieldDidChange:(UITextField *)TextField {
    if ([[TextField text] isEqualToString:@""] || [[TextField text] length] == 7) {
        [[self view] endEditing:YES];
    }
}

- (void)TextFieldDidBeginEditing:(UITextField *)TextField {
    _activeField = TextField;
}

- (void)TextFieldDidEndEditing:(UITextField *)TextField {
    _activeField = nil;
}

- (BOOL)TextFieldShouldReturn:(UITextField *)TextField {
    [TextField resignFirstResponder];
    return YES;
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (BOOL)validateInput {
    int errors = 0;
    
    NSString *name = [_nameTextField text];
    if ([name isEqualToString:@""]) {
        [self errorMarkTextField:_nameTextField];
        errors++;
    }
    else {
        [self validMarkTextField:_nameTextField];
    }
    
    NSString *ssn = [_ssnTextField text];
    if ([ssn length] != 10) {
        [self errorMarkTextField:_ssnTextField];
        errors++;
    }
    else {
        [self validMarkTextField:_ssnTextField];
    }
    
    NSString *address = [_addressTextField text];
    if ([address isEqualToString:@""]) {
        [self errorMarkTextField:_addressTextField];
        errors++;
    }
    else {
        [self validMarkTextField:_nameTextField];
    }
    
    NSString *postalCode = [_postalTextField text];
    if ([postalCode length] != 3) {
        [self errorMarkTextField:_postalTextField];
        errors++;
    }
    else {
        [self validMarkTextField:_postalTextField];
    }
    
    NSString *phone = [_phoneTextField text];
    if ([phone length] != 7) {
        [self errorMarkTextField:_phoneTextField];
        errors++;
    }
    else {
        [self validMarkTextField:_phoneTextField];
    }
    
    NSString *email = [_emailTextField text];
    if (!([email containsString:@"@"] && [email containsString:@"."])) {
        [self errorMarkTextField:_emailTextField];
        errors++;
    }
    else {
        [self validMarkTextField:_emailTextField];
    }
    
    NSString *pass1 = [_passwordTextField text];
    NSString *pass2 = [_repeatPasswordTextField text];
    if (!([pass1 length] > 4 && [pass1 isEqualToString:pass2])) {
        [self errorMarkTextField:_passwordTextField];
        [self errorMarkTextField:_repeatPasswordTextField];
        errors++;
    }
    else {
        [self validMarkTextField:_passwordTextField];
        [self validMarkTextField:_repeatPasswordTextField];
    }
    
    if (errors > 0) {
        return NO;
    }
    return YES;
}

- (void)errorMarkTextField:(UITextField*)TextField {
    [TextField setBackgroundColor:[UIColor colorWithRed:0.95 green:0.5 blue:0.4 alpha:1.0]];
}

- (void)validMarkTextField:(UITextField*)TextField {
    [TextField setBackgroundColor:[UIColor whiteColor]];
}

@end
