//
//  LoginViewController.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "LoginViewController.h"

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
    [self sendLogin:_emailTextfield.text withPassword:_passwordTextField.text];
}

- (void)sendLogin:(NSString*)email
     withPassword:(NSString*)password {
    NSString *loginSOAPBody = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><s:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:a=\"http://www.w3.org/2005/08/addressing\" xmlns:s=\"http://www.w3.org/2003/05/soap-envelope\"><s:Header><a:Action s:mustUnderstand=\"1\">http://imageuploader.digit.is/OrderServiceJS/login</a:Action><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><a:To s:mustUnderstand=\"1\">%@</a:To></s:Header><s:Body><login xmlns=\"http://imageuploader.digit.is\"><email>%@</email><password>%@</password><storeID>%@</storeID></login></s:Body></s:Envelope>", [Properties restService], _emailTextfield.text, _passwordTextField.text, [Properties storeId]];
    
    NSString *url = [Properties restService];
    NSURL *sRequestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *myRequest = [NSMutableURLRequest requestWithURL:sRequestURL];
    NSString *sMessageLength = [NSString stringWithFormat:@"%d", (int)[loginSOAPBody length]];
    
    [myRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [myRequest addValue:[Properties site] forHTTPHeaderField:@"Host"];
    [myRequest addValue: [Properties host] forHTTPHeaderField:@"Origin"];
    [myRequest addValue: sMessageLength forHTTPHeaderField:@"Content-Length"];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody: [loginSOAPBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:myRequest
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                  //    NSLog(@"Response: %@", responseString);
                                      _currUser = [[User alloc] initWithXMLData:data];
                                      // Success
                                      if ([responseString containsString:@"<b:ErrorCode>0</b:ErrorCode>"]) {
                                          [self performSelectorOnMainThread:@selector(login:)
                                                                 withObject:_currUser
                                                              waitUntilDone:NO];
                                      }
                                      else {
                                          // Alert User
                                          [self performSelectorOnMainThread:@selector(loginError:)
                                                                 withObject:nil
                                                              waitUntilDone:NO];
                                      }
                                      if (error) {
                                          NSLog(@"%@", error);
                                      }
                                  }];
    [task resume];
}

- (void)login:(id)sender {
    [self performSegueWithIdentifier:@"LoginSuccess" sender:sender];
}

- (void)loginError:(id)sender {
    [_emailTextfield setBackgroundColor:[UIColor colorWithRed:0.95 green:0.5 blue:0.4 alpha:1.0]];
    [_passwordTextField setBackgroundColor:[UIColor colorWithRed:0.95 green:0.5 blue:0.4 alpha:1.0]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginSuccess"]) {
        [(PhotoViewController*)[segue destinationViewController] setCurrUser:_currUser];
    }
}

@end
