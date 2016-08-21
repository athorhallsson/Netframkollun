//
//  RegisterViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetworkManager.h"
#import "PostalCodeParser.h"

@interface RegisterViewController ()
@property (strong, nonatomic) NSString *selectedLocation;
@property (strong, nonatomic) NSString *selectedPostalCode;
@property (strong) UIPickerView *postalPickerView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init variables for parser
    _locations = [[NSMutableArray alloc] init];
    _pCodes = [[NSMutableArray alloc] init];
     _tempLocation = @"";
    
    // Register notifications
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
    // Get postal codes
    [NetworkManager getPostalCodeswithSender:self];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    toolBar.translucent = true;
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Velja"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(donePressedOnPickerView)];
    toolBar.items = @[barButtonDone];
    _postalTextField.inputAccessoryView = toolBar;
    
    _postalPickerView = [UIPickerView new];
    _postalTextField.inputView = _postalPickerView;
    _postalPickerView.delegate = self;
    _postalPickerView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Buttons

- (IBAction)registerPressed:(UIButton *)sender {
    if ([self validateInput]) {
        User *user = [[User alloc] init];
        user.address = [_addressTextField text];
        user.email = [_emailTextField text];
        user.name = [_nameTextField text];
        user.password = [_passwordTextField text];
        user.pCode = _selectedPostalCode;
        user.phone = [_phoneTextField text];
        user.ssn = [_ssnTextField text];
        [NetworkManager createUser:user withLocation:_selectedLocation withSender:self];
    }
}

- (IBAction)backPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Textfields

- (void)ssnTextFieldDidChange:(UITextField *)textField {
    if ([[textField text] isEqualToString:@""] || [[textField text] length] == 10) {
        [textField resignFirstResponder];
    }
}

- (void)postalTextFieldDidChange:(UITextField *)textField {
    if ([[textField text] isEqualToString:@""] || [[textField text] length] == 3) {
        [textField resignFirstResponder];
    }
}

- (void)phoneTextFieldDidChange:(UITextField *)textField {
    if ([[textField text] isEqualToString:@""] || [[textField text] length] == 7) {
        [textField resignFirstResponder];
    }
}

- (void)TextFieldDidBeginEditing:(UITextField *)textField {
    _activeField = textField;
}

- (void)TextFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    _activeField = nil;
}

- (BOOL)TextFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

// Keyboard

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

// Input validation

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
    if ([postalCode isEqualToString:@""]) {
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

// Login

- (void)login:(id)sender {
    [self performSegueWithIdentifier:@"registerSuccess" sender:sender];
}

- (void)loginError:(id)sender {
    NSLog(@"Login Error");
}

// PickerView

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@ - %@", [_pCodes objectAtIndex:row], [_locations objectAtIndex:row]];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_locations count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    _selectedLocation = [_locations objectAtIndex:row];
//    _selectedPostalCode = [_pCodes objectAtIndex:row];
    [_postalTextField setText:[NSString stringWithFormat:@"%@ - %@", [_pCodes objectAtIndex:row], [_locations objectAtIndex:row]]];
}

- (void)donePressedOnPickerView {
    NSInteger row = [_postalPickerView selectedRowInComponent:0];
    _selectedLocation = [_locations objectAtIndex:row];
    _selectedPostalCode = [_pCodes objectAtIndex:row];
    [_postalTextField resignFirstResponder];
}


@end
