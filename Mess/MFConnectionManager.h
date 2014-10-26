//
//  MFConnectionManager.h
//  ModeoFramework
//
//  Created by Jon on 10/25/14.
//  Copyright (c) 2014 Modeo Vehicles LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum {
    kMFConnectionManagerStateDisconnected = 0,
    kMFConnectionManagerStateScanning,
    kMFConnectionManagerStateConnected
} MFConnectionManagerState;

@class MFConnectionManager;

@protocol MFConnectionManagerDelegate <NSObject>

@optional
- (void)connectionManagerDidConnectToPeripheral:(CBPeripheral *)peripheral;
- (void)connectionManagerDidDisconnectFromPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error;
- (void)connectionManagerDidFailToConnectPeripheral:(CBPeripheral *)peripheral withError:(NSError *)error;

@end

@interface MFConnectionManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (weak, nonatomic) NSObject <MFConnectionManagerDelegate> *delgate;
@property (nonatomic, readonly) CBPeripheral *activePeripheral;
@property (nonatomic, readonly) MFConnectionManagerState state;

- (id)initWithDelegate:(NSObject <MFConnectionManagerDelegate> *)delegate;

- (void)connect;
- (void)disconnect;

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)dict;

//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error;
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;

@end
