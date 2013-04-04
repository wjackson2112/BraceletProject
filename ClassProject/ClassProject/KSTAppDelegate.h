//
//  KSTAppDelegate.h
//  ClassProject
//
//  Created by Will Jackson on 3/22/13.
//  Copyright (c) 2013 Will Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class KSTViewController;

@interface KSTAppDelegate : UIResponder <UIApplicationDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate, NSXMLParserDelegate>{
    NSString *currentStringValue;
    int emailCount;
    NSXMLParser *parser;
    NSTimer *emailCheckTimer;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) KSTViewController *viewController;

@property (strong, nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheral *peripheral;


@end
