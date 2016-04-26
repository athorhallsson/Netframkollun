//
//  DeliveryParser.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "DeliveryParser.h"

@interface DeliveryParser ()

@property (strong, nonatomic) NSString *parseString;
@property (strong, nonatomic) Delivery *currDelivery;

@end

@implementation DeliveryParser

- (id)initWithXMLData:(NSData*)data {
    self = [super init];
    
    _deliveries = [[NSMutableArray alloc] init];
    
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
        _currDelivery = [[Delivery alloc] init];
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    _parseString = [_parseString stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"b:Action"]) {
        [_currDelivery setAction:_parseString];
    }
    else if ([elementName isEqualToString:@"b:Description"]) {
        [_currDelivery setDeliveryDescription:_parseString];
    }
    else if ([elementName isEqualToString:@"b:ID"]) {
        [_currDelivery setDeliveryId:_parseString];
    }
    else if ([elementName isEqualToString:@"b:Price"]) {
        [_currDelivery setPrice:_parseString];
        // Last element, add to array
        [_deliveries addObject:_currDelivery];
    }
}


@end
