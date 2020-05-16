//
//  FKFormViewFieldCell.m
//  FDKK
//
//  Created by lei.FY on 2019/8/12.
//  Copyright © 2019 4dage. All rights reserved.
//

#import "FKFormViewFieldCell.h"


NSNotificationName const FKFormViewFieldCellDidTapLeftButtonNotification =
@"FKFormViewFieldCellDidTapLeftButtonNotification";

NSNotificationName const FKFormViewFieldCellDidTapRightButtonNotification =
@"FKFormViewFieldCellDidTapRightButtonNotification";

NSNotificationName const FKFormViewFieldCellChangeTypeToTimingLabelNotification =
@"FKFormViewFieldCellChangeTypeToTimingLabelNotification";

NSNotificationName const FKFormViewFieldCellChangeTypeChangeRightTitleNotification =
@"FKFormViewFieldCellChangeTypeChangeRightTitleNotification";



@interface FKFormViewFieldCell () <UITextFieldDelegate>

@property (nonatomic, strong) NSTimer *timer;   ///< 计时器
@property (nonatomic, assign) NSUInteger timing;///< 倒计时

@end


@implementation FKFormViewFieldCell


#pragma mark - Init


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    
    self.backgroundColor =FK_BACKBROUND_COLOR;
    
    [self addTextField];
    [self addActionButton];
    [self addTimingLabel];
    [self addSecurityButton];
    [self addLeftButton];
    self.actionButton.hidden = YES;
    self.timingLabel.hidden = YES;
    self.securityButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToTimingLabelWithNotification:) name:FKFormViewFieldCellChangeTypeToTimingLabelNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageRightButtonTitleWithNotification:) name:FKFormViewFieldCellChangeTypeChangeRightTitleNotification object:nil];
    
}


#pragma mark - Interfaces


- (void)setType:(FKFormViewFieldCellType)type {
    if (_type != type) {
        _type = type;
        [self typeDidChange:type];
    }
}

- (void)setField:(FKFormViewField *)field {
    if (_field != field) {
        _field = field;
        [self fieldDidChange:field];
    }
}

- (void)setTiming:(NSUInteger)timing {
    if (_timing != timing) {
        _timing = timing;
        self.timingLabel.text = [NSString stringWithFormat:@"%luS%@", timing, @"重新发送"];
    }
}


#pragma mark - Event Handlers


// Cell的类型改变
- (void)typeDidChange:(FKFormViewFieldCellType)type {
    switch (type) {
        case FKFormViewFieldCellTypeInputOnly: {
            self.actionButton.hidden = YES;
            self.timingLabel.hidden = YES;
            self.securityButton.hidden = YES;
            self.actionLeftButton.hidden = YES;
            [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(0);
                make.right.equalTo(self.contentView).offset(-15);
                make.centerY.equalTo(self.contentView);
            }];
            
            [self stopTimingForTimingLabel];
        } break;
        case FKFormViewFieldCellTypeInputAndActionButton: {
            self.actionButton.hidden = NO;
            self.timingLabel.hidden = YES;
            self.securityButton.hidden = YES;
              self.actionLeftButton.hidden = YES;
            [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(0);
                make.right.equalTo(self.actionButton.mas_left).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
            
            [self stopTimingForTimingLabel];
        } break;
        case FKFormViewFieldCellTypeInputAndTimingLabel: {
            self.actionButton.hidden = YES;
            self.timingLabel.hidden = NO;
            self.securityButton.hidden = YES;
            self.actionLeftButton.hidden = YES;
            [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(0);
                make.right.equalTo(self.timingLabel.mas_left).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
            
            [self startTimingForTimingLabel];
        } break;
        case FKFormViewFieldCellTypeInputAndPassword:{
            self.actionButton.hidden = YES;
            self.timingLabel.hidden = YES;
            self.securityButton.hidden = NO;
            self.actionLeftButton.hidden = YES;
            [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(0);
                make.right.equalTo(self.securityButton.mas_left).offset(-10);
                make.centerY.equalTo(self.contentView);
            }];
        } break;
        case FKformViewFieldCellTypeInputWithLeftButton:{
            self.actionButton.hidden = YES;
            self.timingLabel.hidden = YES;
            self.securityButton.hidden = YES;
            self.actionLeftButton.hidden = NO;
            
            NSString *content = self.actionLeftButton.titleLabel.text;
            UIFont *font = self.actionLeftButton.titleLabel.font;
            CGSize size = CGSizeMake(MAXFLOAT, 30.0f);
            CGSize buttonSize = [content boundingRectWithSize:size
                                                      options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                   attributes:@{ NSFontAttributeName:font}
                                                      context:nil].size;
            
            [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).with.offset(buttonSize.width+30);
                make.right.equalTo(self.contentView.mas_right).offset(0);
                make.centerY.equalTo(self.contentView);
            }];
        }break;
    }
}

// 文本输入框文本改变
- (void)textFieldTextDidChange:(NSNotification *)notification {
    if (notification.object == self.textField) {
        self.field.value = self.textField.text;
    }
}

// field改变
- (void)fieldDidChange:(FKFormViewField *)field {
    if (self.type != FKFormViewFieldCellTypeInputAndTimingLabel) {
        switch (field.type) {
            case FKFormViewFieldTypeInput: {
                self.type = FKFormViewFieldCellTypeInputOnly;
            } break;
            case FKFormViewFieldTypeInputWithRightButton: {
                self.type = FKFormViewFieldCellTypeInputAndActionButton;
            } break;
            case FKFormViewFieldTypeInputAndPassword: {
                 self.type = FKFormViewFieldCellTypeInputAndPassword;
                break;
            }
            case FKformViewFieldTypeInputWithLeftButton:
                self.type = FKformViewFieldCellTypeInputWithLeftButton;
        }
    }
    
    self.textField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:field.placeholder
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightMedium],
                                                 NSForegroundColorAttributeName: FK_TEXTNOTSELECT_COLOR
                                                 }];
    
    if (field.rightButtonTitle) {
        [self.actionButton setTitle:field.rightButtonTitle forState:UIControlStateNormal];
    }
    
    if (field.rightButtonDisableTitle) {
        self.timingLabel.text = field.rightButtonDisableTitle;
    }
    
    self.textField.secureTextEntry = field.isSecurity;
    self.textField.keyboardType = field.keyBoardType;
}

// 点击右边按钮
- (void)actionButtonDidTap:(UIButton *)button {
    [[NSNotificationCenter defaultCenter] postNotificationName:FKFormViewFieldCellDidTapRightButtonNotification object:self.field userInfo:@{@"field": self.field}];
}

- (void)securityButtonDidTap:(UIButton *)sender{
    self.textField.secureTextEntry = !self.textField.secureTextEntry;
    [self.securityButton setImage:[UIImage imageNamed:(self.textField.secureTextEntry)?@"my_eye_close":@"my_eye_open"] forState:UIControlStateNormal];
}

- (void)leftButtonDidTap:(UIButton *)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:FKFormViewFieldCellDidTapLeftButtonNotification object:self.field userInfo:@{@"field": self.field}];
}

// 触发定时器
- (void)timerDidTrigger:(NSTimer *)timer {
    if (self.timing == 0) {
        self.type = FKFormViewFieldCellTypeInputAndActionButton;
    }
    
    self.timing -= 1;
}


#pragma mark - Notification Handlers

- (void)chageRightButtonTitleWithNotification:(NSNotification *)notification {
    if (notification.object != self.field) {
        return;
    }
    FKCountryCodeModel *model = [notification.userInfo objectForKey:@"fieldCountry"];
    self.countryModel = model;
    [self.actionLeftButton setTitle:[model.countryCode stringByAppendingString:@" "] forState:UIControlStateNormal];
}

// 通过通知改变Cell的类型
- (void)changeToTimingLabelWithNotification:(NSNotification *)notification {
    
    if (notification.object != self.field) {
        return;
    }
    
    self.type = FKFormViewFieldCellTypeInputAndTimingLabel;
}


#pragma mark - Helper Methods


// 添加输入框
- (void)addTextField {
    
    // add
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:textField];
    
    // setup
    textField.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    textField.textColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    // layout
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.textField = textField;
}

// 添加按钮
- (void)addActionButton {
    
    // add
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:actionButton];
    
    // setup
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [actionButton setTitle:@"I am Button !" forState:UIControlStateNormal];
    [actionButton setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
    actionButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    actionButton.layer.cornerRadius = 5.0f;
    actionButton.backgroundColor = FK_ITEMGROUP_COLOR;
    [actionButton addTarget:self action:@selector(actionButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    // layout
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    self.actionButton = actionButton;
    
    //添加下划线
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = FK_TEXTNOTSELECT_COLOR;
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
}

// 添加计时的Label
- (void)addTimingLabel {
    
    // add
    UILabel *timingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:timingLabel];
    
    // setup
    [timingLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh+1 forAxis:UILayoutConstraintAxisHorizontal];
    timingLabel.text = @"Iam Timing Label";
    timingLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    timingLabel.textColor = [UIColor whiteColor];
    timingLabel.textAlignment = NSTextAlignmentRight;
    // layout
    [timingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    self.timingLabel = timingLabel;
}

- (void)addSecurityButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    
    [button setImage:[UIImage imageNamed:@"my_eye_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(securityButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    //layout
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.securityButton = button;
}

- (void)addLeftButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    
    //[button setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [button addTarget:self action:@selector(leftButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"my_combo_arrow"] forState:UIControlStateNormal];
    [button setTitleColor:FK_SELECT_COLOR forState:UIControlStateNormal];
    button.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [button setTitle:@"+86 " forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.actionLeftButton = button;
    
}

// 启动计时
- (void)startTimingForTimingLabel {
    self.timing = 10;
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerDidTrigger:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 停止定时器
- (void)stopTimingForTimingLabel {
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - Destroy


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
