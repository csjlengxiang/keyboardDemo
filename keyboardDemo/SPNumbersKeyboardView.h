//
//  SPNumbersKeyboardView.h
//  SavingPlus
//
//  Created by Meng Zhang on 16/1/26.
//  Copyright © 2016年 CreditEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"

@interface SPNumbersKeyboardView : UIView

@property (nonatomic, strong) NSString * inputString;
@property (nonatomic, strong, readonly) NSString * desString;
@property (nonatomic, assign, readonly) float floatValue;
@property (nonatomic, assign, readonly) int intValue;

@property (nonatomic, strong, readonly) RACSignal * errorSig;
@property (nonatomic, strong, readonly) RACSignal * completeSig;
@property (nonatomic, strong, readonly) RACSignal * desSig;

@end
