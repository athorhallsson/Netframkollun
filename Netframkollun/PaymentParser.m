//
//  PaymentParser.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PaymentParser.h"


@interface PaymentParser ()

@property (strong, nonatomic) NSString *parseString;
@property (strong, nonatomic) Payment *currPayment;

@end

@implementation PaymentParser 

- (id)initWithXMLData:(NSData*)data {
    self = [super init];
    
    _payments = [[NSMutableArray alloc] init];
    
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
    if ([elementName isEqualToString:@"b:PriceItem"]) {
        _currPayment = [[Payment alloc] init];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    _parseString = [_parseString stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"b:Action"]) {
        [_currPayment setAction:_parseString];
    }
    else if ([elementName isEqualToString:@"b:Description"]) {
        [_currPayment setPaymentDescription:_parseString];
    }
    else if ([elementName isEqualToString:@"b:ID"]) {
        [_currPayment setPaymentId:_parseString];
    }
    else if ([elementName isEqualToString:@"b:Price"]) {
        [_currPayment setPrice:_parseString];
        // Last element, add to array
        [_payments addObject:_currPayment];
    }
}


@end
