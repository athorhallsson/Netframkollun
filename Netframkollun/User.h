//
//  User.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 24/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *ssn;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *pCode;
@property (nonatomic, strong) NSString *userId;

- (id)initWithXMLData:(NSData*)data;

@end
