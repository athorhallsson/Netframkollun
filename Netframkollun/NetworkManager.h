//
//  NetworkManager.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 20/08/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "PhotoViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "CreateOrderResponseParser.h"
#import "SendViewController.h"

@interface NetworkManager : NSObject

+ (void)getImageTypes:(User *)user
                     :(PhotoViewController *)sender;

+ (void)getDeliveries:(User *)user
                     :(PhotoViewController *)sender;

+ (void)getPayments:(User *)user
                    :(PhotoViewController *)sender;

+ (void)getPriceList:(User *)user
                    :(PhotoViewController *)sender;

+ (void)sendLogin:(NSString*)email
     withPassword:(NSString*)password
       withSender:(id)sender;

+ (void)createUser:(User*)user
      withLocation:(NSString*)location
        withSender:(RegisterViewController*)sender;

+ (void)createOrder:(User*)user
        withPayment:(Payment*)payment
       withDelivery:(Delivery*)delivery
         withPhotos:(NSArray*)photos
        withComment:(NSString*)comment
         withSender:(SendViewController*)sender;

+ (void)uploadPhotos:(NSArray*)photos
          withSender:(SendViewController*)sender;

+ (void)uploadPhoto:(Photo*)photo
         withSender:(SendViewController*)sender;

+ (void)finalizeOrderwithSender:(SendViewController*)sender;

+ (void)getPostalCodeswithSender:(RegisterViewController*)sender;

@end
