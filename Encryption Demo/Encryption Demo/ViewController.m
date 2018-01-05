//
//  ViewController.m
//  Encryption Demo
//
//  Created by ECHINACOOP1 on 2018/1/4.
//  Copyright © 2018年 蔺国防. All rights reserved.
//

#import "ViewController.h"
#import "AESCipher.h"
#import "RSA.h"
#import "CocoaSecurity.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

#pragma mark - Life Cycle

/**
     1. AES  加密解密
     2. RSA  加密解密
     3. MD5  加密
     4. SHA  加密
     5. HMAC 加密
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Private

- (IBAction)encryptAndDecrypt:(id)sender {
    
//    [self AES128Demo];
//    [self RSADemo];
//    [self MD5Demo];
//    [self SHA256Demo];
//    [self HMACDemo];
}

- (void)AES128Demo{
    
    NSString *plainText = self.textField.text;
    NSString *key = @"16BytesLengthKey";
    
    NSString *cipherText = aesEncryptString(plainText, key);
    
    NSLog(@"%@", cipherText);
    
    NSString *decryptedText = aesDecryptString(cipherText, key);
    
    NSLog(@"%@", decryptedText);
    
    self.textLabel.text = [NSString stringWithFormat:@"AES 128 加密方式\n\n加密后内容:%@\n\n解密后内容:%@", cipherText, decryptedText];
}

- (void)RSADemo{
    
    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";
    NSString *privkey = @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----";
    
    NSString *encWithPubKey;
    NSString *decWithPrivKey;
    NSString *encWithPrivKey;
    NSString *decWithPublicKey;
    
    NSString *originString = self.textField.text;
    
    NSLog(@"明文(%d): %@", (int)originString.length, originString);
    
    // Demo: encrypt with public key
    encWithPubKey = [RSA encryptString:originString publicKey:pubkey];
    NSLog(@"Public key 加密: %@", encWithPubKey);
    
    // Demo: decrypt with private key
    decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
    NSLog(@"Private key 解密: %@", decWithPrivKey);
    
    // Demo: encrypt with private key
    encWithPrivKey = [RSA encryptString:originString privateKey:privkey];
    NSLog(@"Private key 加密: %@", encWithPrivKey);
    
    // Demo: decrypt with public key
    decWithPublicKey = [RSA decryptString:encWithPrivKey publicKey:pubkey];
    NSLog(@"Public key 解密: %@", decWithPublicKey);
    
    self.textLabel.text = [NSString stringWithFormat:@"RSA 加密方式\n\nPublic key 加密: %@\n\nPrivate key 解密: %@\n\nPrivate key 加密: %@\n\nPublic key 解密: %@",encWithPubKey,decWithPrivKey,encWithPrivKey,decWithPublicKey];
}

- (void)MD5Demo{
    
    CocoaSecurityResult *md5 = [CocoaSecurity md5:self.textField.text];
    //MD5加密结果
    NSLog(@"MD5加密:%@",md5.hex);
    
    self.textLabel.text = [NSString stringWithFormat:@"MD5 加密方式\n\n%@",md5.hex];
}

- (void)SHA256Demo{
    
    CocoaSecurityResult *sha256 = [CocoaSecurity sha256:self.textField.text];
    //SHA 256加密结果
    NSLog(@"SHA加密:%@",sha256.hex);
}

- (void)HMACDemo{
    
    CocoaSecurityResult *hmacMD5 = [CocoaSecurity hmacMd5:self.textField.text hmacKey:@"123"];
    //hmacMd5结果
    NSLog(@"HMC-MD5 加密方式:%@",hmacMD5.hex);
    
    self.textLabel.text = [NSString stringWithFormat:@"HMAC-MD5 加密方式\n\n%@",hmacMD5.hex];
}




@end
