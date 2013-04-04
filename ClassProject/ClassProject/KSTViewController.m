//
//  KSTViewController.m
//  ClassProject
//
//  Created by Will Jackson on 3/22/13.
//  Copyright (c) 2013 Will Jackson. All rights reserved.
//

#import "KSTViewController.h"

@interface KSTViewController ()

@end

@implementation KSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.sendButton addTarget:self action:@selector(slidersSet) forControlEvents:UIControlEventTouchUpInside];
    
    [self.redSlider addTarget:self action:@selector(slidersChanged) forControlEvents:UIControlEventValueChanged];
    [self.greenSlider addTarget:self action:@selector(slidersChanged) forControlEvents:UIControlEventValueChanged];
    [self.blueSlider addTarget:self action:@selector(slidersChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.redSlider setValue:1];
    [self.greenSlider setValue:1];
    [self.blueSlider setValue:1];
    
    [self.whiteButton  setTag:0];
    [self.redButton    setTag:1];
    [self.greenButton  setTag:2];
    [self.blueButton   setTag:3];
    [self.yellowButton setTag:4];
    [self.purpleButton setTag:5];
    [self.aquaButton   setTag:6];
    [self.blackButton  setTag:7];
    
    [self.whiteButton  addTarget:self action:@selector(colorShortcut:) forControlEvents:UIControlEventTouchUpInside];
    [self.redButton    addTarget:self action:@selector(colorShortcut:) forControlEvents:UIControlEventTouchUpInside];
    [self.greenButton  addTarget:self action:@selector(colorShortcut:) forControlEvents:UIControlEventTouchUpInside];
    [self.blueButton   addTarget:self action:@selector(colorShortcut:) forControlEvents:UIControlEventTouchUpInside];
    [self.yellowButton addTarget:self action:@selector(colorShortcut:) forControlEvents:UIControlEventTouchUpInside];
    [self.purpleButton addTarget:self action:@selector(colorShortcut:) forControlEvents:UIControlEventTouchUpInside];
    [self.aquaButton   addTarget:self action:@selector(colorShortcut:) forControlEvents:UIControlEventTouchUpInside];
    [self.blackButton  addTarget:self action:@selector(colorShortcut:) forControlEvents:UIControlEventTouchUpInside];
    
    [self slidersChanged];
    
    colorUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(slidersSet) userInfo:nil repeats:YES];
     
//    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
//    [callCenter addObserver:self forKeyPath:@"CallEventHandler" options:NSKeyValueObservingOptionNew context:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)slidersSet{
    
    float tempRed = [self.redSlider value]*255;
    float tempGreen = [self.greenSlider value]*255;
    float tempBlue = [self.blueSlider value]*255;
    
    if(tempRed != _redValue || tempGreen != _greenValue || tempBlue != _blueValue){
        _redValue = tempRed;
        _greenValue = tempGreen;
        _blueValue = tempBlue;
        [self setLightValueRed:_redValue green:_greenValue blue:_blueValue];
    }
}

- (void)slidersChanged{
    [self.colorSwatch setBackgroundColor:[[UIColor alloc] initWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.f]];
}

- (void)setLightValueRed: (int) redValue green:(int) greenValue blue:(int) blueValue{
    if(self.peripheral){
        for(CBService *service in self.peripheral.services){
            if ([service.UUID isEqual:[CBUUID UUIDWithString:@"CBF567CD-34AD-4E06-9035-C81BB6EF234C"]]) {
                for(CBCharacteristic *characteristic in service.characteristics){
                    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"CBF567CD-0001-4E06-9035-C81BB6EF234C"]]){
                        NSString *value = [NSString stringWithFormat:@"%02x%02x%02x", redValue, greenValue, blueValue];
                        NSMutableData *data = [NSMutableData data];
                        int idx;
                        for (idx = 0; idx+2 <= value.length; idx+=2) {
                            NSRange range = NSMakeRange(idx, 2);
                            NSString* hexStr = [value substringWithRange:range];
                            NSScanner* scanner = [NSScanner scannerWithString:hexStr];
                            unsigned int intValue;
                            [scanner scanHexInt:&intValue];
                            [data appendBytes:&intValue length:1];
                        }
                        [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    }
                }
            }
        }
    }
}

-(void)colorShortcut: (id) sender {
    switch([sender tag]){
        case 0:
            [self.redSlider setValue:1];
            [self.greenSlider setValue:1];
            [self.blueSlider setValue:1];
            break;
        case 1:
            [self.redSlider setValue:1];
            [self.greenSlider setValue:0];
            [self.blueSlider setValue:0];
            break;
        case 2:
            [self.redSlider setValue:0];
            [self.greenSlider setValue:1];
            [self.blueSlider setValue:0];
            break;
        case 3:
            [self.redSlider setValue:0];
            [self.greenSlider setValue:0];
            [self.blueSlider setValue:1];
            break;
        case 4:
            [self.redSlider setValue:1];
            [self.greenSlider setValue:1];
            [self.blueSlider setValue:0];
            break;
        case 5:
            [self.redSlider setValue:1];
            [self.greenSlider setValue:0];
            [self.blueSlider setValue:1];
            break;
        case 6:
            [self.redSlider setValue:0];
            [self.greenSlider setValue:1];
            [self.blueSlider setValue:1];
            break;
        case 7:
            [self.redSlider setValue:0];
            [self.greenSlider setValue:0];
            [self.blueSlider setValue:0];
            break;
    }
    [self slidersChanged];
    [self slidersSet];
}

/*-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if([keyPath isEqualToString:@"CallEventHandler"]){
        CTCall *call = object;
        if(call.callState == CTCallStateIncoming){
            [self setLightValueRed:0 green:255 blue:0];
        }
    }
}*/

@end
