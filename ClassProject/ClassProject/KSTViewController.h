//
//  KSTViewController.h
//  ClassProject
//
//  Created by Will Jackson on 3/22/13.
//  Copyright (c) 2013 Will Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
//#import <CoreTelephony/CTCallCenter.h>
//#import <CoreTelephony/CTCall.h>

@interface KSTViewController : UIViewController {
    NSTimer *colorUpdateTimer;
}

@property (nonatomic) IBOutlet UISlider *redSlider;
@property (nonatomic) IBOutlet UISlider *greenSlider;
@property (nonatomic) IBOutlet UISlider *blueSlider;
@property (nonatomic) float redValue;
@property (nonatomic) float greenValue;
@property (nonatomic) float blueValue;

@property (nonatomic) CBCentralManager *manager;
@property (nonatomic) CBPeripheral *peripheral;

@property (nonatomic) IBOutlet UIImageView *colorSwatch;
//@property (nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic) IBOutlet UIButton *whiteButton;
@property (nonatomic) IBOutlet UIButton *redButton;
@property (nonatomic) IBOutlet UIButton *greenButton;
@property (nonatomic) IBOutlet UIButton *blueButton;
@property (nonatomic) IBOutlet UIButton *yellowButton;
@property (nonatomic) IBOutlet UIButton *purpleButton;
@property (nonatomic) IBOutlet UIButton *aquaButton;
@property (nonatomic) IBOutlet UIButton *blackButton;

- (void)setLightValueRed: (int) redValue green:(int) greenValue blue:(int) blueValue;
- (void)colorShortcut: (id) sender;

@end
