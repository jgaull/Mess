//
//  MFCommunicationManager.h
//  ModeoFramework
//
//  Created by Jon on 10/26/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class MFCommunicationManager;
@protocol MFCommunicationManagerDelegate <NSObject>

@optional
- (void)bleDidReceiveData:(unsigned char *) data length:(int) length;
- (void)bleDidFailSendingData;

@end

@interface MFCommunicationManager : NSObject <CBPeripheralDelegate>

@property (nonatomic, weak) NSObject <MFCommunicationManagerDelegate> *delegate;

@property (nonatomic, readonly) CBPeripheral *peripheral;

- (id)initWithPeripheral:(CBPeripheral *)peripheral;

- (void)read;
- (void)write:(NSData *)data;

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;

@end
