//
//  User.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 24/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "User.h"

@interface User ()

@property (strong, nonatomic) NSString *parseString;

@end

@implementation User

- (id)initWithXMLData:(NSData*)data {
    self = [super init];

    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    [xmlParser parse];
    
    return self;
}


// XML parser

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _parseString = @"";
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    _parseString = [_parseString stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"b:name"]) {
        [self setName:_parseString];
    }
    else if ([elementName isEqualToString:@"b:address"]) {
        [self setAddress:_parseString];
    }
    else if ([elementName isEqualToString:@"b:email"]) {
        [self setEmail:_parseString];
    }
    else if ([elementName isEqualToString:@"b:ssid"]) {
        [self setSsn:_parseString];
    }
    else if ([elementName isEqualToString:@"b:pcode"]) {
        [self setPCode:_parseString];
    }
    else if ([elementName isEqualToString:@"b:phone"]) {
        [self setPhone:_parseString];
    }
    else if ([elementName isEqualToString:@"b:id"]) {
        [self setUserId:_parseString];
    }
    else if ([elementName isEqualToString:@"b:password"]) {
        [self setPassword:_parseString];
    }
}


@end
