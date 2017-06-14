//
//  TDFScrollLabel.m
//  TDFWaveAnimationDemo
//
//  Created by 黄河 on 2016/11/30.
//  Copyright © 2016年 黄河. All rights reserved.
//

#import "TDFScrollLabel.h"

@interface TDFScrollLabel ()
{
    int _fromValue;
    int _toValue;
}
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation TDFScrollLabel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.scoreFontSize = 24;
        self.descFontSize = 9;
    }
    
    return self;
}

- (void)animationToValue:(NSNumber *)toValue
                duration:(CGFloat)duration
               animation:(BOOL)doAnimation {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.adjustsFontSizeToFitWidth = YES;
    _toValue = toValue.intValue;
    if (!doAnimation) {
        _fromValue = _toValue;
        [self setTextWithValue];
        return;
    }
    NSTimeInterval timeInterval = fabs(duration/(_toValue - _fromValue)) ;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateLabelText:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateLabelText:(NSTimer *)timer {
    if (_fromValue == _toValue) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    _fromValue = _fromValue < _toValue ? _fromValue + 1:_fromValue - 1;
    [self setTextWithValue];
}

- (void)setTextWithValue {
    if (self.callBack) {
        self.callBack(_fromValue);
    }
    NSMutableAttributedString *attributedStriung = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"%d分", nil),_fromValue]];
    [attributedStriung addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.scoreFontSize] range:NSMakeRange(0, attributedStriung.length - 1)];
    [attributedStriung addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.descFontSize] range:NSMakeRange(attributedStriung.length - 1, 1)];
    self.attributedText = attributedStriung;
}

@end
