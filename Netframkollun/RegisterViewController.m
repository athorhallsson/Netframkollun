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
    
    _locations = [[NSMutableArray alloc] init];
    _pCodes = [[NSMutableArray alloc] init];
     _tempLocation = @"";
    
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
    
    [self getPostalCodes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerPressed:(UIButton *)sender {
    NSLog(@"%@", _locations);
    NSLog(@"%@", _pCodes);
    
    
    if ([self validateInput]) {
        [self performSegueWithIdentifier:@"registerSuccess" sender:nil];
    }
}

- (IBAction)backPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ssnTextFieldDidChange:(UITextField *)TextField {
    if ([[TextField text] isEqualToString:@""] || [[TextField text] length] == 10) {
        [TextField resignFirstResponder];
    }
}

- (void)postalTextFieldDidChange:(UITextField *)TextField {
    if ([[TextField text] isEqualToString:@""] || [[TextField text] length] == 3) {
        [TextField resignFirstResponder];
    }
}

- (void)phoneTextFieldDidChange:(UITextField *)TextField {
    if ([[TextField text] isEqualToString:@""] || [[TextField text] length] == 7) {
        [TextField resignFirstResponder];
    }
}

- (void)TextFieldDidBeginEditing:(UITextField *)TextField {
    _activeField = TextField;
}

- (void)TextFieldDidEndEditing:(UITextField *)TextField {
    [TextField resignFirstResponder];
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

// Get Postal Codes

- (NSArray*)getPostalCodes {
    NSString *host = @"http://netframkollun.pedromyndir.is/digit.imageuploader.webservice/orderservice.asmx";
    NSString *sSOAPMessage = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><getPostalCodes xmlns=\"http://imageuploader.digit.is\" /></soap:Body></soap:Envelope>";
    
    NSURL *sRequestURL = [NSURL URLWithString:host];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%d", (int)[sSOAPMessage length]];
    
    [myRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue: @"http://imageuploader.digit.is/getPostalCodes" forHTTPHeaderField:@"SOAPAction"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [sSOAPMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:myRequest delegate:self];
    
    if (theConnection) {
        _webResponseData = [NSMutableData data];
        NSLog(@"Problem");
    }
    else {
        NSLog(@"Some error occurred in Connection");
    }
    return nil;
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.webResponseData  setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.webResponseData  appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Some error in your Connection. Please try again.");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Received Bytes from server: %d", (int)[self.webResponseData length]);
    //NSString *myXMLResponse = [[NSString alloc] initWithBytes: [self.webResponseData bytes] length:[self.webResponseData length] encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",myXMLResponse);
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:_webResponseData];
    // Don't forget to set the delegate!
    xmlParser.delegate = self;
    // Run the parser
    [xmlParser parse];
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%@", elementName);
    if ([elementName isEqualToString:@"Pcode"]) {
        _inPostCode = YES;
    }
    else if ([elementName isEqualToString:@"Location"]) {
         _inLocation = YES;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"%@", string);
    if (_inPostCode) {
        [_pCodes addObject:string];
    }
    else if (_inLocation) {
        _tempLocation = [_tempLocation stringByAppendingString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"%@", elementName);
    if ([elementName isEqualToString:@"Pcode"]) {
        _inPostCode = NO;
    }
    else if ([elementName isEqualToString:@"Location"]) {
        [_locations addObject:_tempLocation];
        _tempLocation = @"";
        _inLocation = NO;
    }
}


@end
