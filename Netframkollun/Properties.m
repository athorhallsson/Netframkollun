//
//  Properties.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "Properties.h"
#import "Photo.h"

@implementation Properties

+ (NSString*)host {
    return @"http://netframkollun.pedromyndir.is";
   // return @"http://dev.digit.is";
}

+ (NSString*)site {
    return @"netframkollun.pedromyndir.is";
  //  return @"dev.digit.is";
    
}

+ (NSString*)restService {
    return [[self host] stringByAppendingString:@"/digit.imageuploader.webservice/orderservicejs.svc"];
}

+ (NSString*)webService {
    return [[self host] stringByAppendingString:@"/digit.imageuploader.webservice/OrderService.asmx"];
}

+ (NSString*)storeId {
    // Pedro
    return @"ad28e5a9-2244-40af-8c3c-05da9eb13efe";
    // Digit dev
    //return @"00000000-0000-0000-0000-000000000000";
}
         
@end
