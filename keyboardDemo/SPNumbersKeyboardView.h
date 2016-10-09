#import <UIKit/UIKit.h>
#import "ReactiveCocoa.h"

@interface SPNumbersKeyboardView : UIView

@property (nonatomic, strong) NSString * inputString;
@property (nonatomic, strong, readonly) NSString * desString;
@property (nonatomic, assign, readonly) int intValue;

@property (nonatomic, strong, readonly) RACSignal * errorSig;
@property (nonatomic, strong, readonly) RACSignal * completeSig;
@property (nonatomic, strong, readonly) RACSignal * desSig;

@end
