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
    [self getPostalCodes];
    
    UIPickerView * postalPickerView = [UIPickerView new];
    _postalTextField.inputView = postalPickerView;
    postalPickerView.delegate = self;
    postalPickerView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Buttons

- (IBAction)registerPressed:(UIButton *)sender {
    if ([self validateInput]) {
        [self performSegueWithIdentifier:@"registerSuccess" sender:nil];
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

// Get Postal Codes

- (void)getPostalCodes {
    NSString *soapBody = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><getPostalCodes xmlns=\"http://imageuploader.digit.is\" /></soap:Body></soap:Envelope>";
    NSString *host = [Properties webService];
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%d", (int)[soapBody length]];
    
    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: @"http://imageuploader.digit.is/getPostalCodes" forHTTPHeaderField:@"SOAPAction"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [soapBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      _webResponseData = data;
                                      NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSLog(@"Response: %@", newStr);
                                      NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:_webResponseData];
                                      xmlParser.delegate = self;
                                      [xmlParser parse];
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
}

// XML parser

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // NSLog(@"%@", elementName);
    if ([elementName isEqualToString:@"Pcode"]) {
        _inPostCode = YES;
    }
    else if ([elementName isEqualToString:@"Location"]) {
         _inLocation = YES;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // NSLog(@"%@", string);
    if (_inPostCode) {
        [_pCodes addObject:string];
    }
    else if (_inLocation) {
        _tempLocation = [_tempLocation stringByAppendingString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // NSLog(@"%@", elementName);
    if ([elementName isEqualToString:@"Pcode"]) {
        _inPostCode = NO;
    }
    else if ([elementName isEqualToString:@"Location"]) {
        [_locations addObject:_tempLocation];
        _tempLocation = @"";
        _inLocation = NO;
    }
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
    [_postalTextField setText:[NSString stringWithFormat:@"%@ - %@", [_pCodes objectAtIndex:row], [_locations objectAtIndex:row]]];
}


@end
