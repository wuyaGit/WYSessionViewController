//
//  WYInputTextView.m
//  TrainSkill
//
//  Created by YANGGL on 2018/1/10.
//  Copyright © 2018年 Xwu. All rights reserved.
//

#import "WYInputTextView.h"

@interface WYInputTextView()

@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation WYInputTextView

#pragma mark - initializer

- (instancetype)init {
    if (self = [super init]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializer];
    }
    return self;
}

- (void)initializer {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:self];

    _placeholderColor = [UIColor lightGrayColor];
    [self layoutUI];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - layout

- (void)layoutUI {
    _placeholderLabel.alpha = self.text.length > 0 || _placeholderText.length == 0 ? 0 : 1;

}

#pragma mark - NSNotificationCenter

- (void)textDidChanged:(NSNotification *)notification {
    if (notification.object == self) {
        [self layoutUI];
    }
}

#pragma mark - getter

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
        _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.alpha = 0;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

#pragma mark - setter

- (void)setText:(NSString *)text {
    [super setText:text];
    [self layoutUI];
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    if (_placeholderText.length > 0) {
        
        self.placeholderLabel.text = _placeholderText;
        self.placeholderLabel.textColor = _placeholderColor;
        [self.placeholderLabel sizeToFit];
        [self sendSubviewToBack:_placeholderLabel];
        
        [self layoutUI];
    }
    
    [super drawRect:rect];
}

- (CGSize)contentSize {
    CGSize size = [super contentSize];
    CGSize maxSize = CGSizeMake(self.frame.size.width, MIN(self.maxTextViewHeight, size.height));
    return maxSize;
}

@end
