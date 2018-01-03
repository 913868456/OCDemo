//
//  ViewController.m
//  Core Bluetooth Demo
//
//  Created by ECHINACOOP1 on 2017/12/27.
//  Copyright © 2017年 蔺国防. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager * centralManager; //中心管理者
@property (strong, nonatomic) CBPeripheral     * bandPeripheral; //蓝牙设备
@property (strong, nonatomic) CBCharacteristic * characteristic; //需要操作的特性

@end

@implementation ViewController

/**
     中心管理者读取外部设备流程
     1.创建中心管理者
     2.扫描并链接外部设备
     3.发现外部设备服务和特性
     4.读取(写入或设置通知)外部服务特性
     5.取消外部设备链接
 */

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Events Response

- (IBAction)connectToDevice:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:weakSelf queue:nil options:nil];
    NSLog(@"创建中心管理者");
}

- (IBAction)disConnectDevice:(id)sender {
    
    [self.centralManager cancelPeripheralConnection:self.bandPeripheral];
}

#pragma mark - Delegate

//CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBManagerStatePoweredOn:
        {
            NSLog(@"扫描外部设备");
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        }
        case CBManagerStatePoweredOff:
            
            break;
        case CBManagerStateResetting:
            
            break;
        case CBManagerStateUnauthorized:
            
            break;
        case CBManagerStateUnsupported:
            
            break;
        case CBManagerStateUnknown:
            
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"外部设备: %@, 广播信息: %@, 信号强度: %@", peripheral, advertisementData, RSSI);
    //筛选指定外设,该蓝牙手环设备名称前缀为"MH08".如果已知蓝牙UUID的话,也可以使用 peripheral.identifier.UUIDString 来明确蓝牙设备
    if ([peripheral.name hasPrefix:@"MH08"] ) {
        self.bandPeripheral = peripheral;        //强引用外部设备对象,否则会释放
        [self.centralManager stopScan];          //发现指定外设后,为了保护电池寿命和节约电量,中心管理者停止扫描
        NSLog(@"链接外部设备: %@", peripheral.name);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"链接外部设备成功");
    __weak typeof(self) weakSelf = self;
    peripheral.delegate = weakSelf;
    //发现外设所有服务
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    //链接外部设备失败
    if (error) {
        NSLog(@"链接外部设备失败:%@",error.localizedDescription);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"断开外部设备链接:%@, %@", peripheral,error.localizedDescription);
}

//CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    NSLog(@"发现外部设备服务");
    for (CBService *service in peripheral.services) {
        NSLog(@"%@\n",service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error) {
        NSLog(@"发现服务特性失败:%@",error.localizedDescription);
        return;
    }
    NSLog(@"发现外部设备服务特性");
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral readValueForCharacteristic:characteristic];
//        if ([characteristic.UUID.UUIDString isEqualToString:@"要进行对写和通知操作的特性UUID"]) {
//            self.characteristic = characteristic;
//             [peripheral readValueForCharacteristic:characteristic];//读操作
//             [peripheral writeValue:@"要写入的数据,NSData类型" forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];写操作
//             [peripheral setNotifyValue:YES forCharacteristic:characteristic];//通知操作
//        }
    }
}

//已经更新特性值(read 和 notify 都会调用该方法)
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"读取特性值失败:%@", error.localizedDescription);
        return;
    }
    NSLog(@"特性:%@, 值: %@", characteristic, characteristic.value);//特性值为NSData类型,根据定义转换成相应类型
    for (CBDescriptor *descriptor in characteristic.descriptors) {
        [peripheral readValueForDescriptor:descriptor];
    }
}

//已经更新描述值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    
    if (error) {
        NSLog(@"读取描述失败:%@", error.localizedDescription);
        return;
    }
    NSLog(@"描述: %@, 值: %@", descriptor, descriptor.value);
}

//已经写入特性值
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
}

//已经更新特性通知状态
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
}

@end
