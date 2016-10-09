//
//  SPNumbersKeyboardView.m
//  SavingPlus
//
//  Created by Meng Zhang on 16/1/26.
//  Copyright © 2016年 CreditEase. All rights reserved.
//

#import "Masonry.h"
#import "SPNumbersKeyboardView.h"

#define KEY_7       @"7"
#define KEY_8       @"8"
#define KEY_9       @"9"
#define KEY_DEL     @"DEL"
#define KEY_4       @"4"
#define KEY_5       @"5"
#define KEY_6       @"6"
#define KEY_1       @"1"
#define KEY_2       @"2"
#define KEY_3       @"3"
#define KEY_0       @"0"
#define KEY_JIA     @"+"
#define KEY_JIAN    @"-"
#define KEY_DOT     @"."
#define KEY_OK      @"OK"
#define KEY_EQUAL   @"="

#define hexColor(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface SPNumbersKeyboardView () <UITextFieldDelegate> {
    RACSubject * _errorSig;
    RACSubject * _completeSig;
    RACSubject * _desSig;
}


@property (nonatomic, strong) UIView * keyboardContainer;
@property (nonatomic, strong) NSDictionary<NSString *, UIButton *> * keyButtons;
@property (nonatomic, assign) BOOL isEqualHidden;

#define KEY(k) self.keyButtons[KEY_ ## k]

@end


@implementation SPNumbersKeyboardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)setInputString:(NSString *)inputString {
    _inputString = inputString;
    if ([inputString isEqualToString:@""] || [inputString isEqualToString:@"+"] || [inputString isEqualToString:@"-"]) {
        _desString = @"0";
        _floatValue = 0;
        _intValue = 0;
    } else {
        _desString = inputString;
        _intValue = [self getSum:inputString];
    }
    [_desSig sendNext:_desString];
    NSLog(@"---- %@ %d %@", _inputString, _intValue, _desString);
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    self.inputString = @"";
    self.isEqualHidden = YES;
    [self initializeSubviews];
    [self setupKeyboardContainer];
    [self setupKeys];
    [self setupRAC];
}

- (NSArray<NSString *> *)allKeys {
    return @[KEY_7, KEY_8, KEY_9, KEY_DEL,
             KEY_4, KEY_5, KEY_6,
             KEY_1, KEY_2, KEY_3,
             KEY_DOT, KEY_0, KEY_OK, KEY_JIA, KEY_JIAN, KEY_EQUAL];
}


- (void)initializeSubviews {
    self.keyboardContainer = [[UIView alloc] init];
    [self addSubview:self.keyboardContainer];
    
    NSMutableDictionary * keys = [@{} mutableCopy];
    for (NSString * key in [self allKeys]) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.keyboardContainer addSubview:button];
        
        button.layer.borderWidth = 0.5 / [UIScreen mainScreen].scale;
        button.layer.borderColor = hexColor(0x8b8b8b).CGColor;
//        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:25];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.mas_key = key;
        [button setTitle:key forState:UIControlStateNormal];
        keys[key] = button;
        
//        if (![key isEqualToString:@"确定"]) {
////            [button setBackgroundImage:[[UIColor whiteColor] image] forState:UIControlStateNormal];
//        }
        
//        [button setBackgroundImage:[[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:0.08] image] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(keyPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.keyButtons = keys;
    
//    [KEY(DEL) setTitle:@"删除" forState:UIControlStateNormal];
//    [KEY(DEL) setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    
//    [self setupUIAppearancebyTheme];
}

- (void)setupKeyboardContainer {
    [self.keyboardContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)setupKeys {
    [KEY(7) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.keyboardContainer.mas_top);
        make.left.equalTo(self.keyboardContainer.mas_left);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(8) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.keyboardContainer.mas_top);
        make.left.equalTo(KEY(7).mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(9) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.keyboardContainer.mas_top);
        make.left.equalTo(KEY(8).mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(JIA) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.keyboardContainer.mas_top);
        make.left.equalTo(KEY(9).mas_right);
        make.right.equalTo(self.keyboardContainer.mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(JIAN) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(JIA).mas_bottom);
        make.left.equalTo(KEY(9).mas_right);
        make.right.equalTo(self.keyboardContainer.mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(4) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.keyboardContainer.mas_left);
        make.top.equalTo(KEY(7).mas_bottom);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(5) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(KEY(4).mas_right);
        make.top.equalTo(KEY(8).mas_bottom);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(6) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(KEY(5).mas_right);
        make.top.equalTo(KEY(9).mas_bottom);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(1) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(4).mas_bottom);
        make.left.equalTo(self.keyboardContainer.mas_left);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(2) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(5).mas_bottom);
        make.left.equalTo(KEY(1).mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(3) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(6).mas_bottom);
        make.left.equalTo(KEY(2).mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
    }];
    
    [KEY(DEL) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(1).mas_bottom);
        make.left.equalTo(self.keyboardContainer.mas_left);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
        make.bottom.equalTo(self.keyboardContainer.mas_bottom);
    }];
    
    [KEY(0) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(2).mas_bottom);
        make.left.equalTo(KEY(DEL).mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
        make.bottom.equalTo(self.keyboardContainer.mas_bottom);
    }];
    
    [KEY(DOT) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(3).mas_bottom);
        make.left.equalTo(KEY(0).mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.25);
        make.bottom.equalTo(self.keyboardContainer.mas_bottom);
    }];
    
    [KEY(OK) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(DEL).mas_bottom);
        make.left.equalTo(KEY(0).mas_right);
        make.right.equalTo(self.keyboardContainer.mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.5);
        make.bottom.equalTo(self.keyboardContainer.mas_bottom);
    }];
    
    [KEY(EQUAL) mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(KEY(DEL).mas_bottom);
        make.left.equalTo(KEY(0).mas_right);
        make.right.equalTo(self.keyboardContainer.mas_right);
        make.width.equalTo(self.keyboardContainer.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.keyboardContainer.mas_height).multipliedBy(0.5);
        make.bottom.equalTo(self.keyboardContainer.mas_bottom);
    }];
}



- (RACSignal *)errorSig {
    return _errorSig;
}

- (void)setupRAC {
    
    _errorSig = [RACSubject subject];
    _completeSig = [RACSubject subject];
    _desSig = [RACSubject subject];
    
    [RACObserve(self, isEqualHidden) subscribeNext:^(NSNumber * hidden) {
        if ([hidden boolValue]) {
            [KEY(EQUAL) setHidden:YES];
            [KEY(OK) setHidden:NO];
        } else {
            [KEY(OK) setHidden:YES];
            [KEY(EQUAL) setHidden:NO];
        }
    }];
}

- (void)changeAppearanceIfNeed {
    NSString * str = self.inputString;
    if (self.inputString.length > 0 && [[self.inputString substringToIndex:1] containsString:@"-"]) {
        str = [self.inputString substringFromIndex:1];
    }
    self.isEqualHidden = !([str containsString:@"+"] || [str containsString:@"-"]);
}

- (void)keyPressed:(id)sender {
    NSString * pressedKey = nil;
    for (NSString * key in [self allKeys]) {
        if ([self.keyButtons[key] isEqual:sender]) {
            pressedKey = key;
            break;
        }
    }
    
//    NSLog(@"key: %@", pressedKey);
    
    if ([pressedKey isEqualToString:KEY_DEL]) {
        if (self.inputString.length > 0) {
            self.inputString = [self.inputString substringToIndex:_inputString.length - 1];
            [self changeAppearanceIfNeed];
        }
        return;
    }
    
    if ([pressedKey isEqualToString:KEY_EQUAL]) {
        NSString * errorString;
        if ([self checkInputString:self.inputString withLastIsEqual:YES withErrorString:&errorString]) {
            
            int sum = [self getSum:self.inputString];
            BOOL lowerThanZero = NO;
            if (sum < 0) {
                lowerThanZero = YES;
                sum *= -1;
            }
            int last1 = sum % 10;
            int last2 = (sum / 10) % 10;
            NSString * tmp = self.inputString;
            if (last1 > 0) {
                tmp = [NSString stringWithFormat:@"%d.%d%d", sum / 100, last2, last1];
            } else if (last1 == 0 && last2 > 0) {
                tmp = [NSString stringWithFormat:@"%d.%d", sum / 100, last2];
            } else if (last1 == 0 && last2 == 0) {
                tmp = [NSString stringWithFormat:@"%d", sum / 100];
            }
            if (lowerThanZero) {
                self.inputString = [@"-" stringByAppendingString:tmp];
            } else {
                self.inputString = tmp;
            }
            
            [self changeAppearanceIfNeed];
            return ;
        } else {
            [_errorSig sendNext:errorString];
            return ;
        }
    }
    
    if ([pressedKey isEqualToString:KEY_OK]) {
        
        NSLog(@"---- 键盘消失");
        [_completeSig sendNext:@"输入成功"];
        return;
    }
    
    NSString * errorString;
    if ([self checkInputString:[self.inputString stringByAppendingString:pressedKey] withLastIsEqual:NO withErrorString:&errorString]) {
        self.inputString = [self.inputString stringByAppendingString:pressedKey];
    } else {
        [_errorSig sendNext:errorString];
    }
    [self changeAppearanceIfNeed];
}

- (BOOL)checkInputString:(NSString *)str withLastIsEqual:(BOOL)lastIsEqual withErrorString:(NSString **)errorString {
    NSString * tmpStr = str;
    if (![[str substringToIndex:1] containsString:@"-"] && ![[str substringToIndex:1] containsString:@"+"]) {
        str = [@"+" stringByAppendingString:str];
        tmpStr = str;
    }
    // 串格式化为+,-打头
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
    NSArray<NSString *> * strs = [str componentsSeparatedByCharactersInSet:set];
    int cnt = (int)strs.count;
    for (NSString * str in strs) {
        cnt--;
        if (cnt == strs.count - 1) continue; // 第一位不计
        if ((!lastIsEqual) && (cnt == 0) && (str.length == 0)) { // 1+2+  这种最后这种是可以输入的, 在最后是等号时候1+2+这种是不可以的，1+2=这种是可以的
            continue;
        }
        NSArray <NSString *> * s = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
        NSString * yuan, * fen;
        if (s.count == 1) {
            yuan = s[0];
            if (yuan.length == 0) { *errorString = @"输入非法"; return NO; }
            if (yuan.length > 1 && [[yuan substringToIndex:1] isEqualToString:@"0"]) { *errorString = @"输入含有前导零"; return NO; } // 前导零不行
            if (yuan.length > 7) { *errorString = @"整数位最多7位长度"; return NO; } // 过长 > 999 999 9
        } else if (s.count == 2) {
            yuan = s[0];
            fen = s[1];
            if (yuan.length == 0) { *errorString = @"输入非法"; return NO; }
            if (yuan.length > 1 && [[yuan substringToIndex:1] isEqualToString:@"0"]) { *errorString = @"输入含有前导零"; return NO; } // 前导零不行
            if (yuan.length > 7) { *errorString = @"整数位最多7位长度"; return NO; } // 过长 > 999 999 9
            if (fen.length > 2) { *errorString = @"小数位最多2位长度"; return NO; }
        } else { *errorString = @"输入非法"; return NO; }
    }
    int sum = [self getSum:tmpStr];
    if (sum > 999999999) {
        *errorString = @"输入求和后太大了哦";
        return NO; // 太大了
    }
    if (sum < -999999999) {
        *errorString = @"输入求和后太小了哦";
        return NO; // 太小了
    }
    return YES;
}

- (int)getSum:(NSString *)str {
    if (str.length > 0 && ![[str substringToIndex:1] containsString:@"-"] && ![[str substringToIndex:1] containsString:@"+"]) {
        str = [@"+" stringByAppendingString:str];
    }
    int sum = 0;
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
    NSArray<NSString *> * strs = [str componentsSeparatedByCharactersInSet:set];
    
    NSMutableArray * cs = [NSMutableArray new];
    for (int i = 0; i < str.length; i++) {
        unichar c = [str characterAtIndex:i];
        if (c == '-') {
            [cs addObject:@"-"];
        } else if (c == '+') {
            [cs addObject:@"+"];
        }
    }
    int cnt = 0;
    BOOL isFirst = YES;
    for (NSString * str in strs) {
        if (isFirst) {
            isFirst = NO;
            continue;
        }
        int cur = 0;
        NSArray <NSString *> * s = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
        NSString * yuan, * fen;
        if (s.count == 1) {
            yuan = s[0];
            cur += [yuan intValue] * 100;
        } else if (s.count == 2) {
            yuan = s[0];
            fen = s[1];
            cur += [yuan intValue] * 100;
            if (fen.length == 1) cur += [fen intValue] * 10;
            if (fen.length == 2) cur += [fen intValue];
        }
        if ([[cs objectAtIndex:cnt] isEqualToString:@"+"]) {
            sum += cur;
        } else {
            sum -= cur;
        }
        cnt ++;
    }
    return sum;
}


@end
