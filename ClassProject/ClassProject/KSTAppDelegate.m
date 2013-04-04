//
//  KSTAppDelegate.m
//  ClassProject
//
//  Created by Will Jackson on 3/22/13.
//  Copyright (c) 2013 Will Jackson. All rights reserved.
//

#import "KSTAppDelegate.h"

#import "KSTViewController.h"

@implementation KSTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[KSTViewController alloc] initWithNibName:@"KSTViewController_iPhone" bundle:nil];
    //} else {
    //    self.viewController = [[KSTViewController alloc] initWithNibName:@"KSTViewController_iPad" bundle:nil];
    //}
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    self.viewController.manager = self.manager;
    
    NSURL *url = [[NSURL alloc] initWithString:@"https://wjackson2112:T0wm1n2p@mail.google.com/mail/feed/atom"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    
    [parser parse];
    
    emailCheckTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkEmailCount) userInfo:nil repeats:YES];
    
    NSString *servUUID = @"CBF567CD-34AD-4E06-9035-C81BB6EF234C";
    CBUUID *cbuuidServ = [CBUUID UUIDWithString:servUUID];
    
    [self.manager scanForPeripheralsWithServices:[NSArray arrayWithObject:cbuuidServ] options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"Found Peripheral");
    
    if( !self.peripheral ) {
        self.peripheral = [[CBPeripheral alloc] init];
    }
    
    self.peripheral = peripheral;
    
    if( !peripheral.isConnected ) {
        [self.manager connectPeripheral:self.peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
    
    [self.manager stopScan];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"Connected");
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:nil];
    for(CBService *service in self.peripheral.services){
        [self.peripheral discoverCharacteristics:nil forService:service];
    }
    
    self.viewController.peripheral = self.peripheral;
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSString *servUUID = @"CBF567CD-34AD-4E06-9035-C81BB6EF234C";
    CBUUID *cbuuidServ = [CBUUID UUIDWithString:servUUID];
    
    [self.manager scanForPeripheralsWithServices:[NSArray arrayWithObject:cbuuidServ] options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey]];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *aService in aPeripheral.services) {
        
        [aPeripheral discoverCharacteristics:nil forService:aService];
        
        NSLog(@"KSTBLEManager: Discovered Service %@", aService.UUID);
        
    }
    
}

- (void) peripheral:(CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    for (CBCharacteristic *aChar in service.characteristics) {
        
        NSLog(@"KSTBLEManager: Discovered Characteristic %@", aChar.UUID);
        
        [_peripheral readValueForCharacteristic:aChar];
        [_peripheral setNotifyValue:YES forCharacteristic:aChar];
        
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    currentStringValue = string;
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"fullcount"]){
        int newCount = [currentStringValue intValue];
        if(newCount > emailCount){
            [self.viewController setLightValueRed:255 green:0 blue:0];
            emailCheckTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(turnOffLight) userInfo:nil repeats:NO];
        }
        emailCount = newCount;
    }
}

-(void) checkEmailCount{
    NSURL *url = [[NSURL alloc] initWithString:@"https://wjackson2112:T0wm1n2p@mail.google.com/mail/feed/atom"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    
    [parser parse];
}

-(void) turnOffLight{
    [self.viewController setLightValueRed:0 green:0 blue:0];
    emailCheckTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkEmailCount) userInfo:nil repeats:YES];
}

@end
